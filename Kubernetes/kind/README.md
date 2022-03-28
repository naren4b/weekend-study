# Create the root CA `naren4biz.in`
```
openssl req -x509 -sha256 -newkey rsa:4096 -keyout ca.key -out ca.crt -days 356 -nodes -subj '/CN=naren4biz Cert Authority'

```

# Install helm 
https://helm.sh/docs/intro/install/
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

# Install kubectl 
https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256) kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

sudo apt install bash-completion -y
source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.
alias k=kubectl
complete -F __start_kubectl k

```
# Install kind 
https://kind.sigs.k8s.io/docs/user/quick-start/#installation
```
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x ./kind
mv ./kind /usr/local/bin/kind
```

# Create a KIND Cluster 1 master 1 worker 
```
CLUSTER_NAME=demo
KIND_NODE_VERSION=v1.22.2
cat > ${CLUSTER_NAME}-config.yaml <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  image: kindest/node:${KIND_NODE_VERSION}
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
  - containerPort: 443
    hostPort: 443
  - containerPort: 1024
    hostPort: 1024  
- role: worker
  image: kindest/node:${KIND_NODE_VERSION}

EOF
kind create cluster --name demo-cluster --config ${CLUSTER_NAME}-config.yaml 
k get nodes -o wide 

```  
                                               
# Install ingress controller 
# ref: https://github.com/naren4b/weekend-study/tree/main/Kubernetes/secure-ingress-e2e
- 1 Nginx 

```
wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

set the nodeSelector

      nodeSelector:
        kubernetes.io/hostname: demo-cluster-control-plane
```

# Install Storage class 
# ref: https://github.com/naren4b/weekend-study/tree/main/Storage
```
mkdir rook-ceph
cd rook-ceph/
 
helm repo add rook-release https://charts.rook.io/release
helm fetch rook-release/rook-ceph --untar

cd rook-ceph/
helm template naren-rook-ceph . -f values.yaml -n rook-ceph>naren-rook-ceph.yaml

kubectl create ns rook-ceph
kubectl apply -f naren-rook-ceph.yaml -n  rook-ceph
kubectl get -f naren-rook-ceph.yaml

wget https://raw.githubusercontent.com/rook/rook/release-1.8/deploy/examples/cluster-test.yaml
kubectl create -f cluster-test.yaml -n rook-ceph
kubectl get pod -n rook-ceph

wget https://raw.githubusercontent.com/rook/rook/release-1.8/deploy/examples/toolbox.yaml
kubectl create -f toolbox.yaml -n rook-ceph
kubectl get pod -n rook-ceph

kubectl -n rook-ceph logs -l app=rook-ceph-operator -f
```
