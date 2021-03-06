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
#### 1. Kind Cluster Setup 
 Following script installs a kind cluster(1M-1W) with 
 - local docker registry
 - `standard` storage class 
 - `nginx`  ingress-controller 
```
cd installation
bash install-kind-cluster.sh

```  
                                               
# Install ingress controller 
ref: https://github.com/naren4b/weekend-study/tree/main/Kubernetes/secure-ingress-e2e
- 1 Nginx 

```
wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

set the nodeSelector

      nodeSelector:
        kubernetes.io/hostname: demo-cluster-control-plane
```

# Install Storage class 
ref: https://github.com/naren4b/weekend-study/tree/main/Storage
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

# Copy the private registry details 
```
DOCKER_CONFIG=$(mktemp -d)
export DOCKER_CONFIG
docker login -u <user>  -p <password> <reg-url>
trap 'echo "Removing ${DOCKER_CONFIG}/*" && rm -rf ${DOCKER_CONFIG:?}' EXIT

KIND_CLUSTER_NAME=demo
for node in $(kind get nodes --name "${KIND_CLUSTER_NAME}"); do
  node_name=${node#node/}
  docker cp "${DOCKER_CONFIG}/config.json" "${node_name}:/var/lib/kubelet/config.json"
  docker exec "${node_name}" systemctl restart kubelet.service; 
 done


```

# Storage 

```
kubectl apply -f https://openebs.github.io/charts/openebs-operator.yaml
Kubectl get sc # check the storage-class name

```


