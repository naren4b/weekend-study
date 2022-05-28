#!/bin/bash
############################################################
# Usage : bash get_haproxy-ingress_chart.sh 
############################################################
read -p 'Enter haproxy-ingress HAPROXY_INGRESS_CHART_VERSION: ' HAPROXY_INGRESS_CHART_VERSION  # 0.13.7
HAPROXY_INGRESS_CHART_VERSION=${HAPROXY_INGRESS_CHART_VERSION:-"0.13.7"} 
echo HAPROXY_INGRESS_CHART_VERSION: $HAPROXY_INGRESS_CHART_VERSION
HAPROXY_INGRESS_APP_VERSION=${HAPROXY_INGRESS_APP_VERSION:-"0.13.7"} 
echo HAPROXY_INGRESS_APP_VERSION: $HAPROXY_INGRESS_APP_VERSION

REPO_URL=https://haproxy-ingress.github.io/charts
REPO_NAME=haproxy-ingress 
REPO_PATH=haproxy-ingress
NAMESPACE=ingress-controller

# Add the repo
helm repo add ${REPO_NAME} ${REPO_URL}

#Update the repo
helm repo update

# Put in a directory 
helm fetch ${REPO_NAME}/${REPO_PATH} --untar --untardir=v${HAPROXY_INGRESS_APP_VERSION} --version ${HAPROXY_INGRESS_CHART_VERSION}

#helm show values ${REPO_NAME}/${REPO_PATH} > values.yaml

echo "${REPO_NAME} ${REPO_URL} is available ${REPO_PATH} at v${HAPROXY_INGRESS_APP_VERSION}"

