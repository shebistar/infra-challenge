#!/bin/sh

cd terraform
terraform init 
terraform apply  -auto-approve
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
cd ..
curl -o v0.3.6.tar.gz https://codeload.github.com/kubernetes-sigs/metrics-server/tar.gz/v0.3.6 && tar -xzf v0.3.6.tar.gz
kubectl apply -f metrics-server-0.3.6/deploy/1.8+/
nohup kubectl proxy &
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
kubectl apply -f https://raw.githubusercontent.com/hashicorp/learn-terraform-provision-eks-cluster/update-eks-module-18.0.4/kubernetes-dashboard-admin.rbac.yaml
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')
aws iam get-role --role-name "AWSServiceRoleForElasticLoadBalancing" || aws iam create-service-linked-role --aws-service-name "elasticloadbalancing.amazonaws.com"
kubectl create -f kubernetes/namespace.yaml -n hivemind
kubectl apply -f kubernetes/deployment.yaml -n hivemind
kubectl apply -f kubernetes/service.yaml -n hivemind
kubectl get service hivemind-app -o wide -n hivemind
ELB=$(kubectl get service hivemind-app -n hivemind -o json | jq -r '.status.loadBalancer.ingress[].hostname')
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
echo "This is the URL for the service:"
echo ""
echo ""
echo ""
echo "Checking Service:"
#### TODO: Wait for service to be online in the previous command, with sleep or while
curl -m3 -v $ELB

#cd ..

echo "Process finalized, press ENTER to continue"
read nothing
