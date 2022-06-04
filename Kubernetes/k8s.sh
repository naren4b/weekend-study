#! /bin/bash
kube=$1
if [ -z $kube ];then
 echo  "Select the  environment: "
 echo "--------------------------------------------"
 ls -XA1 ~/.kube/
 echo "--------------------------------------------"
 echo -n "Env : "
 read kube
fi

kube="${kube:-config}"
export KUBECONFIG=~/.kube/$kube
#ref : https://stackoverflow.com/questions/50406142/kubectl-bash-completion-doesnt-work-in-ubuntu-docker-container
source /etc/bash_completion
alias k=kubectl
complete -F __start_kubectl k
source <(kubectl completion bash | sed 's/kubectl/k/g')

echo "------------------cluster-info--------------------------"

export do="-o yaml --dry-run=client"

k cluster-info

echo "------------------context-info--------------------------"

k config get-contexts

echo "--------------------------------------------------------"
echo ""


#curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
#sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
#chmod +x kubectl
#mkdir -p ~/.local/bin/kubectl
#mv ./kubectl ~/.local/bin/kubectl

export oy="-o yaml"
export now="--force --grace-period=0"
