while [ "$ELB" != "null" ] 
do
echo "waiting on ELB to come up......."
ELB=$(kubectl get service hivemind-app -n hivemind -o json | jq -r '.status.loadBalancer.ingress[].hostnam')
sleep 10
done

