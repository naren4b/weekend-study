# Install gitlab with helm e2e 



#### Create KIND cluster 

```
cat >kind-config.yaml <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: gitlab
nodes:
  - role: control-plane
    kubeadmConfigPatches:
      - |
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "ingress-ready=true"
    extraPortMappings:
      - containerPort: 80
        hostPort: 80
        protocol: TCP
      - containerPort: 443
        hostPort: 443
        protocol: TCP
    image: kindest/node:v1.23.5
    extraMounts:
      - containerPath: /var/lib/kubelet/config.json
        hostPath: /root/.docker/config.json	
  - role: worker
    image: kindest/node:v1.23.5
    extraMounts:
      - containerPath: /var/lib/kubelet/config.json
        hostPath: /root/.docker/config.json			

EOF

kind get kubeconfig --name=gitlab > gitlab-kubeconfig
export KUBECONFIG=gitlab-kubeconfig

```
##### Add gitlab Repo 
```
REPO_URL=https://charts.gitlab.io/
REPO_NAME=gitlab
REPO_PATH=gitlab
NAMESPACE=gitlab
RELEASE_NAME=us-west
VERSION=5.10.0
```

#### Add the repo 
```
helm repo add ${REPO_NAME} ${REPO_URL}
#Update the repo 
helm repo update
# Search the repo 
helm search repo ${REPO_NAME}/${REPO_PATH}
helm fetch ${REPO_NAME}/${REPO_PATH} --untar --untardir=v${VERSION}  --version=${VERSION}
helm show values ${REPO_NAME}/${REPO_PATH} --version=${VERSION} > ${RELEASE_NAME}-${REPO_NAME}-values.yaml

```

#### Get the Template 
```
echo helm template ${RELEASE_NAME}-${REPO_NAME} ${REPO_NAME}/${REPO_PATH} --version=${VERSION}  -f ${RELEASE_NAME}-${REPO_NAME}-values.yaml -n ${NAMESPACE} --debug --dry-run 
```

#### Install 
```
kubectl create namespace gitlab 
helm template ${RELEASE_NAME}-${REPO_NAME} ${REPO_NAME}/${REPO_PATH} --version=${VERSION}  -f ${RELEASE_NAME}-${REPO_NAME}-values.yaml -n ${NAMESPACE} >${RELEASE_NAME}-${REPO_NAME}-out.yaml

```
#### Get the initial password for root
kubectl get secret us-west-gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' -n gitlab| base64 --decode ; echo

#### Check the ingress 
```
NODEPORT=$(kubectl get svc -n gitlab us-west-gitlab-nginx-ingress-controller  -ojsonpath='{.spec.ports[1].nodePort}')
echo "https://gitlab.cicd.local:${NODEPORT}

```



 


