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
RELEASE_NAME=test
VERSION=5.10.2
DOMAIN=127.0.0.1.nip.io
EXTERNAL_IP=127.0.0.1
```

# Get the gitlab repo in local 
```
mkdir -p {manifests,charts}
helm repo add ${REPO_NAME} ${REPO_URL}
helm repo update
helm fetch ${REPO_NAME}/${REPO_PATH} --untar --untardir=./charts/v${VERSION}  --version=${VERSION} gitlab
```

# Get the Template 
```
helm template ${RELEASE_NAME} ./charts/v${VERSION}/gitlab -f values/sample-gitlab-values.yaml  --create-namespace  -n {NAMESPACE} 
```

# Install the gitlab 

#### Create the namespace 
```
kubectl create namespace -n {NAMESPACE} -o yaml
```

#### External Object store configurations 
```
kubectl create secret generic s3cmd-config --from-file=config=resources/s3cmd-config.txt  -n gitlab --dry-run=client -o yaml >manifests/s3cmd-config.yaml

BUCKET_NAME=gitlab-lfs-storage
SECRET_NAME=objectstore-lfs
kubectl create secret generic ${SECRET_NAME} --from-file=connection=resources/objectstore-artifacts.yaml  -n gitlab --dry-run=client -o yaml >manifests/${BUCKET_NAME}.yaml

BUCKET_NAME=gitlab-artifacts-storage
SECRET_NAME=objectstore-artifacts
kubectl create secret generic ${SECRET_NAME} --from-file=connection=resources/objectstore-artifacts.yaml  -n gitlab --dry-run=client -o yaml >manifests/${BUCKET_NAME}.yaml

BUCKET_NAME=gitlab-uploads-storage
SECRET_NAME=objectstore-uploads
kubectl create secret generic ${SECRET_NAME} --from-file=connection=resources/objectstore-artifacts.yaml  -n gitlab --dry-run=client -o yaml >manifests/${BUCKET_NAME}.yaml

BUCKET_NAME=gitlab-packages-storage
SECRET_NAME=objectstore-packages
kubectl create secret generic ${SECRET_NAME} --from-file=connection=resources/objectstore-artifacts.yaml  -n gitlab --dry-run=client -o yaml >manifests/${BUCKET_NAME}.yaml
```

#### Install the gitlab chart 
```
kubectl create -f 
helm template ${RELEASE_NAME} ./charts/v${VERSION}/gitlab -f values/sample-gitlab-values.yaml  --create-namespace  -n {NAMESPACE} > manifests/${RELEASE_NAME}-gitlab-out.yaml
kubectl apply -f manifests/${RELEASE_NAME}-gitlab-out.yaml -n ${NAMESPACE}
kubectl get pod -n ${NAMESPACE} -w 
```

#### Get the initial password for root
kubectl get secret us-west-gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' -n gitlab| base64 --decode ; echo

#### Check the ingress 
```
NODEPORT=$(kubectl get svc -n gitlab us-west-gitlab-nginx-ingress-controller  -ojsonpath='{.spec.ports[1].nodePort}')
echo "https://gitlab.${DOMAIN}:${NODEPORT}

```












