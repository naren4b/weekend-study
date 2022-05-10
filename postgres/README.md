# Helm install postgres-operator

```
helm repo add postgres-operator-charts https://opensource.zalando.com/postgres-operator/charts/postgres-operator
helm repo update
helm install postgres-operator postgres-operator-charts/postgres-operator -n postgres-operator  --create-namespace
```
# Helm install postgres-operator-ui (Optional)
```
helm repo add postgres-operator-ui-charts https://opensource.zalando.com/postgres-operator/charts/postgres-operator-ui
helm repo update
helm install postgres-operator-ui postgres-operator-ui-charts/postgres-operator-ui

kubectl port-forward svc/postgres-operator-ui 8081:80

```
# Install postgresql cluster 
```
cd postgres/
helm template . 
```

# Sample manifest files

```
---
# Source: postgres/templates/gitlab-postgres.yaml
apiVersion: "acid.zalan.do/v1"
kind: postgresql
metadata:
  name: "gitlab-gitlab"
  namespace: gitlab
spec:
  teamId: gitlab
  volume:
    size: 1Gi
    storageClass: local-path
  numberOfInstances: 2
  users:
    gitlab:
    - superuser
    - createdb
  databases:
    gitlab: gitlab
  preparedDatabases: {}
  postgresql:
    version: "14"

```


# how to get password

gitlab.gitlab-gitlab.credentials.postgresql.acid.zalan.do

# get name of master pod of acid-minimal-cluster
export PGMASTER=$(kubectl get pods -o jsonpath={.items..metadata.name} -l spilo-role=master,cluster-name= -n default)

# set up port forward
kubectl port-forward $PGMASTER 6432:5432 -n default






