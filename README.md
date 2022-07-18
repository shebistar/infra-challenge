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

    docker build -t greeter:v1 .
    
## Running the application (With Docker for local testing)

    docker run -p 8080:8080 greeter:v1    
    
## Testing the application (With Docker for local testing)
    
    curl localhost:8080


## Resources

- [AWS Cloud Development Kit](https://aws.amazon.com/cdk/)
- Docker build images for Go (https://docs.docker.com/language/golang/build-images/)

