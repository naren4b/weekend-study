#!/bin/bash

####################################################################
# USAGE:
#    bash  setup_cluster.sh 
# This will install the helm and setup the argocd Helm chart 
####################################################################

read -p 'Enter cluster-name: ' clusterName
read -p 'Enter cluster context(i.e. kind-blue): ' clustercontext
read -p 'Enter kube-config-path: ' kubeconfigPath
read -p 'Enter Server Address: ' clusterurl

export KUBECONFIG="${kubeconfigPath}"
kubectl config set-context ${clustercontext}
kubectl cluster-info
echo "Create sa argocd-manager in kube-system namespace"
kubectl create sa -n kube-system  argocd-manager

generate_cluster_yaml(){
`
{
cat > ${1}/${2}_cluster.yaml <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: $2
  labels:
    argocd.argoproj.io/secret-type: cluster
type: Opaque
stringData:
  name: $2
  server: $3
  config: |
    {"bearerToken":"$4","tlsClientConfig":{"insecure":false,"caData":"$5"}}
EOF
}
`

}

# get_secrets gets the argocd-manger-secret from all the clusters
# File is saved as clusterName-argo-cluster-secret.yaml in current directory
get_secrets(){
    secretFolderName="argo-cluster-secrets"
    mkdir -p $secretFolderName
    secretname=`kubectl get sa argocd-manager -n kube-system -o jsonpath="{.secrets[0].name}"`
    token=`kubectl get secret "${secretname}" -n kube-system -o jsonpath="{.data.token}" | base64 -d`
    ca_crt=`kubectl get secret "${secretname}" -n kube-system -o jsonpath="{.data.ca\.crt}"`
    generate_cluster_yaml $secretFolderName $clusterName $clusterurl $token $ca_crt
}

get_secrets