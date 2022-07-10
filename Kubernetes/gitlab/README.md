# Install Kubernetes cluster 
#### 1. Kind Cluster Setup 
 Following script installs a kind cluster(1M-1W) with 
 - local docker registry
 - `standard` storage class 
 - `nginx`  ingress-controller 
```
cd installation
bash install-kind-cluster.sh

```

# Install minimum gitlab 
```
cd installation
bash install-git.sh

```

# Install minimum gitlab 
```
cd installation
bash uninstall-git.sh

```
# Install Kubernetes cluster 
#### Delete the local kind cluster (unrecoverable)
```
cd installation
bash uninstall-kind-cluster.sh

```