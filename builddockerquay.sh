#!/bin/bash
dockerrepo="quay.io/juansebasrodriguez"
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws
echo -n "Type app version to build: "
read ver
echo ""
echo "Container to be build/push: $dockerrepo/greeter:$ver"
echo ""
docker build -t $dockerrepo/greeter:$ver .
docker build -t $dockerrepo/greeter:latest .
docker push $dockerrepo/greeter:$ver
docker push $dockerrepo/greeter:latest
echo -n "Do you want to run the app Y/N: "
read ans
case $ans in
#Y | y) echo "Launch the app by opening the URL: http://localhost:8080"; docker run -p 8080:8080 $dockerrepo/greeter:$ver;; 
Y | y) echo "Launch the app by opening the URL: http://localhost:80"; docker run -p 80:80 $dockerrepo/greeter:$ver;; 
esac
