#!/bin/sh
set -o errexit
source static_config.sh

# Clean up  
kubectl delete  -f out/{KIND_CLUSTER_NAME}-out.yaml -n gitlab 
kubectl delete ns gitlab



