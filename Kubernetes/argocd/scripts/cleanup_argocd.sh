#!/bin/bash

####################################################################
# USAGE:
#    bash cleanup.sh
# This will clean up all the generated files and directory 
####################################################################

read -p 'Enter kube-config-path: ' kubeconfigPath
kubeconfigPath=${kubeconfigPath:-/c/Users/npanda/.kube/config}
echo $kubeconfigPath
read -p 'Enter cluster context(i.e. kind-blue): ' clustercontext
read -p 'Enter release-name: ' releaseName

REPO_PATH=_out/argo-cd
RELEASE_NAME=$releaseName
NAMESPACE=argocd

export KUBECONFIG="${kubeconfigPath}"
kubectl config set-context ${clustercontext}
kubectl cluster-info | head -1 
kubectl apply -f _out/${RELEASE_NAME}-out.yaml -n ${NAMESPACE} --force 

rm -rf _out 


