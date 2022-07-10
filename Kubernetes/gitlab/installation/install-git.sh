#!/bin/sh
set -o errexit
source config.sh

#updatethe dependent charts
helm dep update 
helm template ${RELEASE_NAME} gitlab/ --create-namespace --namespace gitlab >out/${KIND_CLUSTER_NAME}-out.yaml 

# Test the 
kubectl create  -f out/${KIND_CLUSTER_NAME}-out.yaml -n gitlab --dry-run=client

kubectl create ns gitlab
kubectl create  -f out/${KIND_CLUSTER_NAME}-out.yaml -n gitlab 


