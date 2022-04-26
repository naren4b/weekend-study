#! /bin/bash
kube=$1
export KUBECONFIG=~/.kube/${kube:-config}
alias k=kubectl
complete -F __start_kubectl k
source <(kubectl completion bash | sed 's/kubectl/k/g')
k cluster-info
