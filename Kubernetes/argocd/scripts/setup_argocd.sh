#!/bin/bash

####################################################################
# USAGE:
#    bash setup_argocd.sh 
# This will install the helm and setup the argocd Helm chart 
####################################################################

read -p 'Enter release-name: ' releaseName

# update or add argocd repo
REPO_URL=https://argoproj.github.io/argo-helm
REPO_NAME=argo
REPO_PATH=argo-cd
NAMESPACE=argocd
RELEASE_NAME=$releaseName 

# Add the repo
helm repo add ${REPO_NAME} ${REPO_URL}

#Update the repo
helm repo update


# Get the Templates
helm fetch ${REPO_NAME}/${REPO_PATH} --untar


# Make a copy of the default value files
helm show values ${REPO_NAME}/${REPO_PATH} >${RELEASE_NAME}-values.yaml
echo "vi ${RELEASE_NAME}-values.yaml"

# Default  Argocd deployment file 
helm template ${RELEASE_NAME} ${REPO_NAME}/${REPO_PATH} -f values.yaml --create-namespace -n ${NAMESPACE} --debug --dry-run >original_out.yaml



