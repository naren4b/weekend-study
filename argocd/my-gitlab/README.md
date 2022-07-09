# Install gitlab with helm e2e 


|Reference                    | Website                                                                                      |
|---------------------------- |----------------------------------------------------------------------------------------------|
|Gitlab                       | https://gitlab.com/gitlab-org/charts/gitlab/-/tree/master/                                   |
|Minikube                     | https://minikube.sigs.k8s.io/docs/start/                                                     |
|Geo                          | https://gitlab.com/gitlab-org/charts/gitlab/-/tree/master/doc/advanced/geo                   |
|advanced/geo                 | https://docs.gitlab.com/charts/advanced/geo/                                                 |
|Installing GitLab using Helm | https://docs.gitlab.com/charts/installation/index.html                                       |
|Offline Gitlab               | https://docs.gitlab.com/ee/topics/offline/quick_start_guide.html                             |
|Geo Constraint               | https://docs.gitlab.com/ee/install/requirements.html#additional-requirements-for-gitlab-geo  |

# Installation instruction 

#### 1. Install a kubernetes cluster 
ref: https://github.com/naren4b/weekend-study/tree/main/Kubernetes/cluster-setup-vm

#### 2. install storage class 
```
kubectl create -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml

```

####  3. Install nginx ingress controller 
```
NODE_NAME=$(kubectl get nodes | tail -1 | awk '{ print $1 }')

kubectl label nodes  ${NODE_NAME} --overwrite=true app.kubernetes.io/component=controller  app.kubernetes.io/instance=ingress-nginx  app.kubernetes.io/name=ingress-nginx ingress-ready=true kubernetes.io/os=linux 
kubectl create -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

```

#### 4. Check the Charts file test-gitlab/Chart.yaml
```
# Edit if needed line 24 and 28
vi test-gitlab/Chart.yaml

```

#### 5. Check the vaules file test-gitlab/values.yaml
```

# modify if needed the lines marked with TODO
vi test-gitlab/values.yaml

```

#### 6. Check the values file test-gitlab/values.yaml
```
RELEASE_NAME=test
NS=gitlab

helm template ${RELEASE_NAME} test-gitlab -n ${NS} >${RELEASE_NAME}-gitlab-out.yaml
kubectl apply -n ${NS} -f ${RELEASE_NAME}-gitlab-out.yaml
```
#### 7. Check the pod/ing status in the cluster 
```
NS=gitlab
kubectl get pods -n ${NS}
kubectl get ing -n ${NS}

```

#### 8. Get the password  
```
RELEASE_NAME=test
NS=gitlab
PASSWORD=$(kubectl get secret -n ${NS} ${RELEASE_NAME}-gitlab-initial-root-password -ojsonpath='{.data.password}' -n gitlab| base64 --decode ; echo)
echo user-id: root
echo password:  ${PASSWORD}

```

#### 9. Access  the portal 
```
DNS=$(cat test-gitlab/values.yaml | grep domain | awk '{print $2}' | sed 's/.*/gitlab.&/')
echo https://${DNS}

```



