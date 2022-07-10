- https://gitlab.com/gitlab-org/cloud-native/gitlab-operator/-/releases
- https://gitlab.com/gitlab-org/cloud-native/gitlab-operator/-/tree/master

# Install Operator through Helm 
```
helm repo add gitlab-operator https://gitlab.com/api/v4/projects/18899486/packages/helm/stable
helm repo update
helm install gitlab-operator gitlab-operator/gitlab-operator --create-namespace --namespace gitlab-system
```






