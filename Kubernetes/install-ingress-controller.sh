ref: https://github.com/haproxytech/helm-charts/tree/main/kubernetes-ingress
mkdir haproxytech
cd haproxytech
helm repo add haproxytech https://haproxytech.github.io/helm-charts
helm fetch haproxytech/kubernetes-ingress --untar
cd kubernetes-ingress 

helm template naren-haproxytech . -f values.yaml -n haproxytech-controller>naren-haproxytech.yaml
k create ns haproxytech-controller

k apply -f naren-haproxytech.yaml -n haproxytech-controller
k get -f naren-haproxytech.yaml

# ref: https://metallb.universe.tf/installation/

mkdir metallb
cd metallb
helm repo add metallb https://metallb.github.io/metallb
helm fetch metallb/metallb --untar
cd metallb

helm template naren-metallb . -f values.yaml -n metallb-system >naren-metallb.yaml

#MetalLB configs are set in values.yaml under configInLine:


