#!/bin/bash

####################################################################
# USAGE:
#    bash  install_argocd.sh <dc-name> 
# This will install the helm and setup the argocd Helm chart 
####################################################################



read -p 'Enter cluster sepcific value file path: ' valuePath
read -p 'Enter cluster-name: ' clusterName
read -p 'Enter cluster context(i.e. kind-blue): ' clustercontext
read -p 'Enter kube-config-path: ' kubeconfigPath
read -p 'Enter Server Address: ' clusterurl

REPO_PATH=argo-cd
MY_RELEASE=clusterName
NAMESPACE=argocd

export KUBECONFIG="${kubeconfigPath}"
kubectl config set-context ${clustercontext}
kubectl cluster-info | head -1 

# Generate argocd installation master template for the cluster 
helm template ${MY_RELEASE} ${REPO_PATH} -f ${valuePath} \
              --create-namespace -n ${NAMESPACE} \
			  --debug --dry-run >${MY_RELEASE}_out.yaml

kubectl create namespace ${NAMESPACE}
kubectl apply -f ${REPO_PATH}/crds
kubectl apply -f ${MY_RELEASE}_out.yaml -n ${NAMESPACE} --force 

kubectl get pod -n ${NAMESPACE} 
kubectl wait --for=condition=Running -l app.kubernetes.io/instance=${MY_RELEASE} -n ${NAMESPACE} 

admin password=`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`
# To test everything locally 
echo kubectl port-forward svc/${MY_RELEASE}-argocd-server -n ${NAMESPACE} 8080:443
echo vist: https://localhost:8080















