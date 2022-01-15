# Ref: [MetalLB v0.11.0](https://metallb.universe.tf/installation/)
```
mkdir metallb
cd metallb
helm repo add metallb https://metallb.github.io/metallb
helm fetch metallb/metallb --untar
cd metallb
#MetalLB configs are set in values.yaml under configInLine:
vi values.yaml

###########################################################################################################################
#configInline:
#  address-pools:
#   - name: default
#     protocol: layer2
#     addresses:
#     - 10.1.1.1/32
###########################################################################################################################

helm template naren-metallb . -f values.yaml -n metallb-system >naren-metallb.yaml
```

# Ref: [HaproxyTech](https://github.com/haproxytech/helm-charts/tree/main/kubernetes-ingress)
```
mkdir haproxytech
cd haproxytech
helm repo add haproxytech https://haproxytech.github.io/helm-charts
helm fetch haproxytech/kubernetes-ingress --untar
cd kubernetes-ingress 

vi values.yaml
###########################################################################################################################
#controller
#  kind: DaemonSet    # can be 'Deployment' or 'DaemonSet'
#  nodeSelector:
#    kubernetes.io/hostname: naren-worker1
#
#service:
#    enabled: false    # set to false when controller.kind is 'DaemonSet' and controller.daemonset.useHostPorts is true
###########################################################################################################################
helm template naren-haproxytech . -f values.yaml -n haproxytech-controller>naren-haproxytech.yaml
k create ns haproxytech-controller
k apply -f naren-haproxytech.yaml -n haproxytech-controller
k get -f naren-haproxytech.yaml
```




