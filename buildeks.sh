#!/bin/sh

cd terraform
terraform init
terraform apply
cd ../kubernetes
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
curl -o v0.3.6.tar.gz https://codeload.github.com/kubernetes-sigs/metrics-server/tar.gz/v0.3.6 && tar -xzf v0.3.6.tar.gz
kubectl apply -f metrics-server-0.3.6/deploy/1.8+/
nohup kubectl proxy &
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
kubectl apply -f https://raw.githubusercontent.com/hashicorp/learn-terraform-provision-eks-cluster/main/kubernetes-dashboard-admin.rbac.yaml
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')
kubectl create -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml
kubectl get service hivemind-app -o wide -n hivemind
ELB=$(kubectl get service hivemind-app -o json | jq -r '.status.loadBalancer.ingress[].hostname')
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

curl -m3 -v $ELB

cd ..

echo "Process finalized, press ENTER to continue"
read nothing
