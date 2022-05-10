# Install gitlab with helm e2e 

# Create KIND cluster 

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
# Add gitlab Repo 
```
REPO_URL=https://charts.gitlab.io/
REPO_NAME=gitlab
REPO_PATH=gitlab
NAMESPACE=gitlab
RELEASE_NAME=sample
VERSION=5.10.2
DOMAIN=10.181.136.59.nip.io
EXTERNAL_IP=10.181.136.59
```

# Add the repo 
```
helm repo add ${REPO_NAME} ${REPO_URL}
#Update the repo 
helm repo update
# Search the repo 
helm search repo ${REPO_NAME}/${REPO_PATH}
helm fetch ${REPO_NAME}/${REPO_PATH} --untar --untardir=v${VERSION}  --version=${VERSION}
helm show values ${REPO_NAME}/${REPO_PATH} --version=${VERSION} > ${RELEASE_NAME}-${REPO_NAME}-values.yaml

```

# Get the Template 
```
echo helm template ${RELEASE_NAME}-${REPO_NAME} ${REPO_NAME}/${REPO_PATH} --version=${VERSION}  -f ${RELEASE_NAME}-${REPO_NAME}-values.yaml -n ${NAMESPACE} --debug --dry-run 
```

# Install 
```
kubectl create namespace gitlab -o yaml 
helm template ${RELEASE_NAME} v${VERSION}/${REPO_NAME} -f ${RELEASE_NAME}-${REPO_NAME}-values.yaml -n ${NAMESPACE} >${RELEASE_NAME}-${REPO_NAME}-out.yaml

kubectl apply -f ${RELEASE_NAME}-${REPO_NAME}-out.yaml -n ${NAMESPACE}
kubectl get pod -n ${NAMESPACE} -w 

```
# Get the initial password for root
kubectl get secret ${RELEASE_NAME}-gitlab-initial-root-password -ojsonpath='{.data.password}' -n gitlab| base64 --decode ; echo

# Check the ingress 
```
echo "https://gitlab.${DOMAIN}"

```

