#!/bin/bash

####################################################################
# USAGE:
#    bash setup_argocd.sh 
# This will install the helm and setup the argocd Helm chart 
####################################################################

read -p 'Enter cluster-name: ' clusterName

# update or add argocd repo
REPO_URL=https://argoproj.github.io/argo-helm
REPO_NAME=argo
REPO_PATH=argo-cd
NAMESPACE=argocd
MY_RELEASE=clusterName # release cluster name

# Add the repo
helm repo add ${REPO_NAME} ${REPO_URL}

#Update the repo
helm repo update

# Get the Templates
helm fetch ${REPO_NAME}/${REPO_PATH} --untar

# Get the default value files
helm show values ${REPO_NAME}/${REPO_PATH} >values.yaml
# Make a copy of the default value files
helm show values ${REPO_NAME}/${REPO_PATH} >${MY_RELEASE}-values.yaml
echo "vi ${MY_RELEASE}-values.yaml"

# Default  Argocd deployment file 
helm template ${MY_RELEASE} ${REPO_NAME}/${REPO_PATH} -f values.yaml --create-namespace -n ${NAMESPACE} --debug --dry-run >original_out.yaml



