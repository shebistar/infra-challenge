# Prereq install Argo CD CLI
# Linux sudo curl --silent --location -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.4.7/argocd-linux-amd64
# MacOS brew install argocd

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.4.7/manifests/install.yaml
#linux Install
# sudo curl --silent --location -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.4.7/argocd-linux-amd64
# MacOS Install

# brew install argocd

sleep 120

#Authenticate to ArgoCD

argocd login --core

CONTEXT_NAME=`kubectl config view -o jsonpath='{.current-context}'`
argocd cluster add $CONTEXT_NAME


# Change the context so the command uses argocd namespace

kubectl config set-context --current --namespace=argocd

# check if you are using the right repo/branch (in case you have cloned the repo)

argocd app create hivemind-app --repo https://github.com/shebistar/infra-challenge.git --revision stage --path kubernetes --dest-server https://kubernetes.default.svc --dest-namespace hivemind 

# now sync the app

argocd app sync hivemind-app

# leave the context back to default
kubectl config set-context --current --namespace=default



