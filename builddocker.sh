#!/bin/bash
#dockerrepo="public.ecr.aws/a7r4i9q7"
dockerrepo="public.ecr.aws/f8u3r2y0/greeter"
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws
echo -n "Type app version to build: "
read ver
echo ""
echo "Container to be build/push: $dockerrepo/greeter:$ver"
echo ""
echo "docker repo $dockerrepo and version $ver  full repo   $dockerrepo:$ver"
sed "s/^ENV VERSION=.*/ENV VERSION=$ver/" Dockerfile >Dockerfile.new
mv Dockerfile.new Dockerfile
docker buildx build --platform linux/amd64,linux/arm64 --push -t $dockerrepo:$ver .
docker buildx build --platform linux/amd64,linux/arm64 --push -t $dockerrepo:latest .
docker push $dockerrepo:$ver
docker push $dockerrepo:latest
echo -n "Do you want to run the app locally? Y/N: "
read ans
case $ans in
#Y | y) echo "Launch the app by opening the URL: http://localhost:8080"; docker run -p 8080:8080 $dockerrepo/greeter:$ver;; 
Y | y) echo "Launch the app by opening the URL: http://localhost:80"; docker run -p 80:8080 $dockerrepo:$ver;; 
esac
