#!/bin/bash

# bash install_argocd.sh generate <dc-name>
# bash install_argocd.sh template <dc-name>
REPO_URL=https://argoproj.github.io/argo-helm
REPO_NAME=argo
REPO_PATH=argo-cd
NAMESPACE=argocd
ACTION=$1
MY_RELEASE=$2

# Add the repo
helm repo add ${REPO_NAME} ${REPO_URL}

#Update the repo
helm repo update

# Get the Templates
helm fetch ${REPO_NAME}/${REPO_PATH} --untar

# if chart is already added
if [ "$ACTION" == "generate" ]; then
	# Show the default value
	helm show values ${REPO_NAME}/${REPO_PATH} >values.yaml
	helm show values ${REPO_NAME}/${REPO_PATH} >${MY_RELEASE}-values.yaml
	echo "edit the value file ${MY_RELEASE}-values.yaml"
else
	# Get the Template
	helm template ${MY_RELEASE} ${REPO_NAME}/${REPO_PATH} -f values.yaml --create-namespace -n ${NAMESPACE} --debug --dry-run >original_out.yaml

	# Get the Template
	helm template ${MY_RELEASE} ${REPO_NAME}/${REPO_PATH} -f values.yaml -f ${MY_RELEASE}-values.yaml --create-namespace -n ${NAMESPACE} --debug --dry-run >${MY_RELEASE}_out.yaml

	echo "Check the ${MY_RELEASE}_out.yaml vs original_out.yaml file "

	kubectl apply -f ${MY_RELEASE}_out.yaml --dry-run=client
fi
echo kubectl  apply -f ${REPO_PATH}/crds
echo kubectl apply -f ${MY_RELEASE}-out.yaml -n ${NAMESPACE}
echo admin password :
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

echo kubectl port-forward svc/${MY_RELEASE}-argocd-server -n ${NAMESPACE} 8080:443
echo vist: https://localhost:8080

