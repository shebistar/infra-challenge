# Hivemind's Infrastructure Challenge

The challenge consists in deploying a web service in a highly available environment using ECS.

- Deploy to AWS using Terraform or CDK.

- Set `HELLO_TAG` to a unique value.

- See if you can capture logs.

- Bonus points if you add a url parameter to the greeter.

We should be able to deploy your solution in any AWS account.

## Building the application (Without Docker)

You can build and run a go app in many ways, easiest is the following:

    go build -o greeter greeter.go
    ./greeter

## Building the application (With Docker for local testing)

    ./build.sh
    
    Type app version to build: v1.1 #(Type version here)
    
    Do you want to run the app Y/N: y
    Launch the app by opening the URL: http://localhost:8080
    Hivemind's Go Greeter
    You are running the service with this tag:  Helloooo World!

    
## Testing the application (With Docker for local testing) Open your favorite browser or simply run from the CLI
    
    curl localhost:8080


## Resources

- [AWS Cloud Development Kit](https://aws.amazon.com/cdk/)
- Docker build images for Go (https://docs.docker.com/language/golang/build-images/)

