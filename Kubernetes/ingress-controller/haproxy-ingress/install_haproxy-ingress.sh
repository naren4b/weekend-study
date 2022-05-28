#!/bin/bash

############################################################
# Usage : bash install_haproxy-ingress.sh
############################################################

NAMESPACE=ingress-controller


read -p 'Enter kube-config-path(default /root/.kube/config): ' KUBECONFIG
KUBECONFIG=${KUBECONFIG:-/c/Users/npanda/.kube/config}
echo ${KUBECONFIG}

read -p 'Enter cluster name(dev/dc1/dc4/dc5): (default dev) ' CLUSTER_NAME
CLUSTER_NAME=${CLUSTER_NAME:-"dev"}
echo CLUSTER_NAME: ${CLUSTER_NAME}
EXTRA_VALUE_FILE_PATH="-f ../../../helm-cluster-configs/thirdparty/ndac-haproxy-ingress-values.yaml"
echo EXTRA_VALUE_FILE_PATH: ${EXTRA_VALUE_FILE_PATH} 

read -p 'Enter HAPROXY_INGRESS CHART VERSION default ("0.13.7"): ' HAPROXY_INGRESS_CHART_VERSION # 0.13.7
HAPROXY_INGRESS_CHART_VERSION=${HAPROXY_INGRESS_CHART_VERSION:-"0.13.7"}
echo HAPROXY_INGRESS_CHART_VERSION: $HAPROXY_INGRESS_CHART_VERSION

read -p 'Enter HAPROXY_INGRESS APP VERSION default ("0.13.7"): ' HAPROXY_INGRESS_APP_VERSION # 0.13.7
HAPROXY_INGRESS_APP_VERSION=${HAPROXY_INGRESS_APP_VERSION:-"0.13.7"}
echo HAPROXY_INGRESS_APP_VERSION: $HAPROXY_INGRESS_APP_VERSION
echo "updated the ndac-haproxy-ingress-values.yaml value file with latest"
read -p "Are you sure to install in current cluster Yes(Yy) default No? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
cp  v${HAPROXY_INGRESS_APP_VERSION}/haproxy-ingress/values.yaml ../../../helm-cluster-configs/thirdparty/ndac-haproxy-ingress-values.yaml
fi
mkdir out
# Create the Template file with the input
echo ""
echo helm template ${CLUSTER_NAME} v${HAPROXY_INGRESS_APP_VERSION}/haproxy-ingress/ ${EXTRA_VALUE_FILE_PATH} --create-namespace --include-crds -n ${NAMESPACE}
echo ""
helm template ${CLUSTER_NAME} v${HAPROXY_INGRESS_APP_VERSION}/haproxy-ingress/ ${EXTRA_VALUE_FILE_PATH} --create-namespace --include-crds -n ${NAMESPACE} >out/${CLUSTER_NAME}-deploy-haproxy-ingress.yaml
echo "Template file location "
ls out/${CLUSTER_NAME}-deploy-haproxy-ingress.yaml 

read -p "Are you sure to install in current cluster(Yy) ? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Installing haproxy-ingress ..."
    export KUBECONFIG="${KUBECONFIG}"
    kubectl cluster-info
    kubectl create namespace ${NAMESPACE}
    kubectl apply -f out/${CLUSTER_NAME}-deploy-haproxy-ingress.yaml -n ${NAMESPACE}
    echo 
    echo "Wait for the pods to come up "
    echo 
    kubectl wait --for=condition=Ready pod  -l app.kubernetes.io/instance=${CLUSTER_NAME} -n ${NAMESPACE} --timeout=30s
    echo ""
else
    echo export KUBECONFIG="${KUBECONFIG}"
    echo kubectl cluster-info
    echo kubectl create namespace ${NAMESPACE}
    echo kubectl apply -f out/${CLUSTER_NAME}-deploy-haproxy-ingress.yaml -n ${NAMESPACE}

fi
