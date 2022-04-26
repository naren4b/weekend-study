read -p 'Enter kube-config-path for argocd: ' kubeconfigPath
read -p 'Enter cluster context(i.e. kind-blue): ' clustercontext
export KUBECONFIG="${kubeconfigPath}"
kubectl config set-context ${clustercontext}
kubectl cluster-info | head -1

# Add the cluster.yaml file to attach the cluster to argocd mgmt 
kubectl apply -f argo-cluster-secrets/ -n argocd
echo "Cluster is added to Argocd "
echo "Now set up the application"
echo "kubectl apply -f argo.yaml -n argocd "