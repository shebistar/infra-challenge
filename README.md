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


# Building the app for EKS

## First to configure Terraform

### Prerequisites:

- Terraform installed
- an AWS account with the IAM permissions listed on the EKS module documentation,
- AWS CLI configured
- AWS IAM Authenticator
- kubectl
- wget (required for installing the eks module)

### All values in repo are ready for deploying the cluster if the prerequisites are OK.

## Interesting files:

- vpc.tf (Definition for VPC, take a look in case you have overlaping with another VPC)
- security-groups.tf (Definition for Security Groups, in case port 22 is not enough, update the policy)
- versions.tf: In case an update is needed on any of the modules
- eks-cluster.tf: You can define versions for EKS and instance types for worker nodes, as well as the Auto Scalling Group Desired Capacity)

### Starting with Terraform to deploy EKS

#### Step one is to initialize terraform

    terraform init
    Initializing modules...

    Initializing the backend...

    Initializing provider plugins...
    -- Output ommitted

Terraform has been successfully initialized!

#### Step two is to deploy EKS using terraform

    terraform apply
    module.eks.module.fargate.data.aws_partition.current: Reading...
    module.eks.data.aws_iam_policy_document.cluster_deny_log_group[0]: Reading...
    -- Output ommitted
    
    Do you want to perform these actions?
    Terraform will perform the actions described above.
    Only 'yes' will be accepted to approve.

    Enter a value: yes

    
##### This process can take up to 10 minutes, so go grab a coffee or tea.


    random_string.suffix: Creating...
    random_string.suffix: Creation complete after 0s [id=9VuZOcFn]
    module.eks.aws_iam_policy.cluster_elb_sl_role_creation[0]: Creating...
    module.eks.aws_iam_policy.cluster_deny_log_group[0]: Creating...
    -- Output ommitted 
    
    
## Resources

- [AWS Cloud Development Kit](https://aws.amazon.com/cdk/)
- Docker build images for Go (https://docs.docker.com/language/golang/build-images/)
- Terraform and EKS (https://learn.hashicorp.com/tutorials/terraform/eks)


