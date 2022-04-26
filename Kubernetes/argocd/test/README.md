# Install cluster 1 
```

kind create cluster --config=blue-kind-config.yaml
kind create cluster --config=green-kind-config.yaml

```
# install helm
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm_version=$(helm version --short)
echo "Helm installed version: ${helm_version} "
```
[README.md](../README.md)