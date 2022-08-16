# Hivemind's Infrastructure Challenge

The challenge consists in deploying a web service in a highly available environment using ECS.

- Deploy to AWS using Terraform or CDK.

- Set `HELLO_TAG` to a unique value.

- See if you can capture logs.

- Bonus points if you add a url parameter to the greeter.

We should be able to deploy your solution in any AWS account.

# E2E Diagram of the solution:

![E2E Diagram](https://github.com/shebistar/infra-challenge/blob/stage/E2E_Architecture.jpg?raw=true)

- This solution is condensed in two scripts, builddocker.sh and buildeks.sh. The first one is to generate the container needed for deploying in the EKS cluster, the second one is to generate the infrastructure needed to deploy the solution.


## Building the application (Without Docker)

You can build and run a go app in many ways, easiest is the following:

    go build -o greeter greeter.go
    ./greeter

# Prerequisites for building with Docker

- Having configured the aws cli with your Access keys: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html

- Having a public ECR repository created and accesible (you need the repo name for next step): Go to Example 1 in https://docs.aws.amazon.com/cli/latest/reference/ecr/create-repository.html

## Building the application (With Docker for local testing)

- Edit Dockerfile for changing the `HELLO_TAG` variable

- Take a look at the line `ENV HELLO_TAG="Hellooooo World!"` in the Dockerfile file and change the variable as you wish"

- Edit ECR repository in case you want to use a different one that matches with your AWS account

  - in the builddocker.sh script, look for the `dockerrepo="public.ecr.aws/XXXXXXXX"`, and use your desired repo

## Execute the buildocker.sh script

    ./builddocker.sh
    
    "Login Succeeded
    Type app version to build: v1.15 

    Container to be build/push: public.ecr.aws/a7r4i9q7/greeter:v1.15

    docker repo public.ecr.aws/a7r4i9q7 and version v1.15  full repo   public.ecr.aws/a7r4i9q7/greeter:v1.15

    -- Output omitted 
    
    latest: digest: sha256:eeaa86ac46bd7e19c48b66c6b6c112d79b0ea9cafac06bb1c2ee32ff278b4ea3 size: 949
    Do you want to run the app locally? Y/N: Y
    
    Launch the app by opening the URL: http://localhost:80
    Hivemind's Go Greeter
    You are running the service with this tag:  Hellooooo World!
    This is my version:  v1.15

    
## Testing the application (With Docker for local testing) Open your favorite browser http://localhost:80 or simply run from the CLI
    
    curl localhost:80


# Building the app for EKS

## First to configure Terraform

### Prerequisites:

- Terraform installed
- an AWS account with the IAM permissions listed on the EKS module documentation
- AWS CLI configured
- AWS IAM Authenticator
- kubectl
- curl (required for installing the eks module)

### All values in repo are ready for deploying the cluster if the prerequisites are OK.

## Interesting files:

- `vpc.tf` (Definition for VPC, take a look in case you have overlaping with another VPC)
- `security-groups.tf` (Definition for Security Groups, in case port 22 is not enough, update the policy)
- `versions.tf`: In case an update is needed on any of the modules
- `eks-cluster.tf`: You can define versions for EKS and instance types for worker nodes, as well as the Auto Scalling Group Desired Capacity)

## Starting with Terraform to deploy EKS

### 1. Initialize terraform

#### Go to terraform directory:

	$ cd terraform

	$ terraform init
    Initializing modules...

    Initializing the backend...

    Initializing provider plugins...
    -- Output omitted

Terraform has been successfully initialized!

### 2. Deploy EKS using terraform

	$ terraform apply
    module.eks.module.fargate.data.aws_partition.current: Reading...
    module.eks.data.aws_iam_policy_document.cluster_deny_log_group[0]: Reading...
    -- Output omitted
    
    Do you want to perform these actions?
    Terraform will perform the actions described above.
    Only 'yes' will be accepted to approve.

    Enter a value: yes

    
#### This process can take up to 10 minutes, so go grab a coffee or tea.


    random_string.suffix: Creating...
    random_string.suffix: Creation complete after 0s [id=9VuZOcFn]
    module.eks.aws_iam_policy.cluster_elb_sl_role_creation[0]: Creating...
    module.eks.aws_iam_policy.cluster_deny_log_group[0]: Creating...
    -- Output omitted 
    
### 3. Configure kubectl for deploying the App

#### After provisioning the EKS cluster, you need to configure kubectl

	$ aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

	Added new context arn:aws:eks:eu-central-1:8306238XXXXX:cluster/hivemind-eks-XXXXXXXX to ~.kube/config

### 4. Deploy metrics-server for monitoring

	$ cd ../kubernetes

	$ curl -o v0.3.6.tar.gz https://codeload.github.com/kubernetes-sigs/metrics-server/tar.gz/v0.3.6 && tar -xzf v0.3.6.tar.gz

	$ kubectl apply -f metrics-server-0.3.6/deploy/1.8+/
 	clusterrole.rbac.authorization.k8s.io/system:aggregated-metrics-reader created
	clusterrolebinding.rbac.authorization.k8s.io/metrics-server:system:auth-delegator created

	-- Output omitted 
 
### 5. Verify deployment of metrics server
	
	$ kubectl get deployment metrics-server -n kube-system

### 6. Deploy Kubernetes Dashboard

	$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
	namespace/kubernetes-dashboard created
	serviceaccount/kubernetes-dashboard created
	service/kubernetes-dashboard created
	secret/kubernetes-dashboard-certs created

	-- Output omitted

### 7. Launch kubectl proxy to access to Web UI

	$ kubectl proxy
	Starting to serve on 127.0.0.1:8001

- Use the following URL to access the dashboard: http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

### 8. Create authentication resources for accessing the Dashboard (Don't close the window used for kubectl proxy for this), open a new terminal

	$ kubectl apply -f https://raw.githubusercontent.com/hashicorp/learn-terraform-provision-eks-cluster/main/kubernetes-dashboard-admin.rbac.yaml
	serviceaccount/admin-user created
	clusterrolebinding.rbac.authorization.k8s.io/admin-user created

### 9. Generate the authentication token for the dashboard:

	$ kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')

### 10. Copy and paste the Token for authenticating the dashboard

	Name:         service-controller-token-wz2gl
	Namespace:    kube-system
	Labels:       <none>
	Annotations:  kubernetes.io/service-account.name: service-controller
              kubernetes.io/service-account.uid: 09614dc9-bc12-4595-9985-4210a8442a3c

	Type:  kubernetes.io/service-account-token

	Data
	====
	ca.crt:     1066 bytes
	namespace:  11 bytes
	token:      -- Output omitted

Copy and Paste the token generated on the previous step and Click on `Sign in`

![E2E Diagram](https://github.com/shebistar/infra-challenge/blob/stage/Kubernetes_Dashboard_Sign_In.png?raw=true)

# Deploy App on EKS

### Check role for ELB

	$ aws iam get-role --role-name "AWSServiceRoleForElasticLoadBalancing" || aws iam create-service-linked-role --aws-service-name "elasticloadbalancing.amazonaws.com"

	{
    "Role": {
        "Path": "/aws-service-role/elasticloadbalancing.amazonaws.com/",
        "RoleName": "AWSServiceRoleForElasticLoadBalancing",
        "RoleId": "AROA4CZIJXSQ5TRGM6SKM",
	-- Output omitted


### Create namespace

#### Go to kubernetes folder
        
	$ kubectl create -f kubernetes/namespace.yaml

#### Deploy Application

	$ kubectl apply -f kubernetes/deployment.yaml 
	$ kubectl apply -f kubernetes/service.yaml


#### Get URL for Application

	$ kubectl get service hivemind-app -o wide -n hivemind
	NAME               TYPE           CLUSTER-IP    EXTERNAL-IP                                                                 PORT(S)        AGE   SELECTOR
	hidemind-app	   LoadBalancer   XXX.XX.XX.X   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-XXXXXXXXX.eu-central-1.elb.amazonaws.com   80:XXXXX/TCP   XXm   app=hivemind-app

- Take the value in the `EXTERNAL-IP` column and use a browser to access to the Site:

- It should display something like this:

	Hello, XXX.XX.XX.XX:XXXXX! I'm XXXXXXXXXXXXX!(EXTRA string=This is my HELLO_TAG, string=XXXXXXXXXXX, string=This is my VERSION, string=vX.XX)

   
# TL;DR (Check prerequisites)

## Docker build

	$./builddocker.sh

## EKS Build

	$./buildeks.sh


## Resources

- [AWS Cloud Development Kit](https://aws.amazon.com/cdk/)
- Docker build images for Go (https://docs.docker.com/language/golang/build-images/)
- Terraform and EKS (https://learn.hashicorp.com/tutorials/terraform/eks)


