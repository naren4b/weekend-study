#!/bin/bash

####################################################################
# USAGE:
#    bash  install_argocd.sh <dc-name> 
# This will install the helm and setup the argocd Helm chart 
####################################################################

read -p 'Enter release-name: ' releaseName
read -p 'Enter cluster sepcific value file path: ' valuePath
valuePath=${valuePath:-_out/${releaseName}-values.yaml}
echo $valuePath
read -p 'Enter kube-config-path: ' kubeconfigPath
kubeconfigPath=${kubeconfigPath:-/c/Users/npanda/.kube/config}
echo $kubeconfigPath
read -p 'Enter cluster context(i.e. kind-blue): ' clustercontext
read -p 'Enter Server Address: ' clusterurl

REPO_PATH=_out/argo-cd
RELEASE_NAME=$releaseName
NAMESPACE=argocd

export KUBECONFIG="${kubeconfigPath}"
kubectl config set-context ${clustercontext}
kubectl cluster-info | head -1 


# Generate argocd installation master template for the cluster 
helm template ${RELEASE_NAME} ${REPO_PATH} -f ${valuePath} \
              --create-namespace -n ${NAMESPACE} \
			  --debug --dry-run >_out/${RELEASE_NAME}-out.yaml

kubectl create namespace ${NAMESPACE}
kubectl apply -f ${REPO_PATH}/crds
kubectl apply -f _out/${RELEASE_NAME}-out.yaml -n ${NAMESPACE} --force 

kubectl get pod -n ${NAMESPACE} 
kubectl wait --for=condition=Ready pod -l app.kubernetes.io/instance=${RELEASE_NAME} -n ${NAMESPACE} 

password=`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`
echo admin password $password
# To test everything locally 
echo kubectl port-forward svc/${RELEASE_NAME}-argocd-server -n ${NAMESPACE} 8080:443
echo vist: https://localhost:8080















