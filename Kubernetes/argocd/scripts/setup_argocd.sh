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
OUTPUT_DIR=_out

# Add the repo
helm repo add ${REPO_NAME} ${REPO_URL}

#Update the repo
helm repo update

# Get the Templates
helm fetch ${REPO_NAME}/${REPO_PATH} --untar --untardir ${OUTPUT_DIR}

# Make a copy of the default value files
helm show values ${REPO_NAME}/${REPO_PATH} >${OUTPUT_DIR}/${RELEASE_NAME}-values.yaml
echo "vi ${OUTPUT_DIR}/${RELEASE_NAME}-values.yaml"

# Default  Argocd deployment file
helm template ${RELEASE_NAME} ${REPO_NAME}/${REPO_PATH} -f ${OUTPUT_DIR}/${RELEASE_NAME}-values.yaml --create-namespace -n ${NAMESPACE} --debug --dry-run >${OUTPUT_DIR}/original_out.yaml
