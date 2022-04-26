#!/bin/bash

####################################################################
# USAGE:
#    bash setup_argocd.sh 
# This will install the helm and setup the argocd Helm chart 
####################################################################

read -p 'Enter release-name: ' releaseName

rm -rf ${releaseName}



