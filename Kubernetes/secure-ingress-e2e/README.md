# Create the root CA `naren4biz.in` and application crts
```
docker run -it --rm -v ${HOME}:/root/ -v ${PWD}:/work -w /work --net host alpine sh
apk add openssl 
NAME=naren4biz
openssl req -x509 -sha256 -newkey rsa:4096 -keyout ca.key -out ca.crt -days 356 -nodes -subj '/CN=naren4biz Cert Authority'
openssl req -new -newkey rsa:4096 -keyout ${NAME}.key -out ${NAME}.csr -nodes -subj '/CN=${NAME}'
openssl x509 -req -sha256 -days 365 -in ${NAME}.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out ${NAME}.crt

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
cat > secure-ingress-e2e-demo-config.yaml <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  image: kindest/node:v1.22.2
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
  - containerPort: 443
    hostPort: 443
  - containerPort: 1024
    hostPort: 1024  
- role: worker
  image: kindest/node:v1.22.2  
- role: worker 
  image: kindest/node:v1.22.2
- role: worker
  image: kindest/node:v1.22.2
EOF
kind create cluster --name demo-cluster --config secure-ingress-e2e-demo-config.yaml 
k get nodes -o wide 

```  
                                               
# Install ingress controller 
- 1 Nginx 

```
wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

set the nodeSelector

      nodeSelector:
        kubernetes.io/hostname: demo-cluster-control-plane
```

- 2 HaproxyTech
#TODO

# Create a Sample Application 

# 0 - Create the `naren4biz.in` Application

# Set up default main app

# Docker for the default Application files 
```
mkdir naren4biz
cd naren4biz
cat > index.html <<EOF 
<!DOCTYPE html>
<html>
<body>
<p style="color:blue;">Welcome to naren4biz.in </p>
</body>
</html>
EOF

cat > error.html <<EOF 
<!DOCTYPE html>
<html>
<body>
<p style="color:red;">You don't have access to this page at naren4biz.in </p>
</body>
</html>
EOF

cat > Dockerfile <<EOF 
FROM nginx:alpine
COPY . /usr/share/nginx/html
EOF
docker build -t naren4b/naren4biz:1.0.0 .
docker login -u ${DOCKER_USERID} -p ${DOCKER_PASSWORD}
docker push naren4b/naren4biz:1.0.0
cd ..

```
# Application k8s manifest file 
```
NAME=naren4biz
k create ns ${NAME}
cat > ${NAME}.yaml <<EOF 
kind: Pod
apiVersion: v1
metadata:
  name: ${NAME}
  labels:
    app: ${NAME}
spec:
  containers:
  - name: ${NAME}
    image: naren4b/naren4biz:1.0.0
---
kind: Service
apiVersion: v1
metadata:
  name: ${NAME}
spec:
  selector:
    app: ${NAME}
  ports:
  - port: 80
---

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${NAME}
spec:
  rules:
  - host: naren4biz.in
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: ${NAME}
            port:
             number: 80
  tls:
  - hosts:
      - naren4biz.in
    secretName: ${NAME}-tls              

EOF
k create -f ${NAME}.yaml -n ${NAME}

# Create the `naren4biz.in` CRT
kubectl create secret generic ${NAME}-tls --from-file=tls.crt=${NAME}.crt --from-file=tls.key=${NAME}.key --from-file=ca.crt=ca.crt -n ${NAME}

```



# 1 - Create the `finance.naren4biz.in` Application
```
NAME=finance
k create ns ${NAME}
cat > ${NAME}.yaml <<EOF 
kind: Pod
apiVersion: v1
metadata:
  name: ${NAME}
  labels:
    app: ${NAME}
spec:
  containers:
  - name: ${NAME}
    image: hashicorp/http-echo:0.2.3
    args:
    - "-text=${NAME}"
---
kind: Service
apiVersion: v1
metadata:
  name: ${NAME}
spec:
  selector:
    app: ${NAME}
  ports:
  - port: 5678 

---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${NAME}
spec:
  rules:
  - host: ${NAME}.naren4biz.in
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: ${NAME}
            port:
              number: 5678
  tls:
  - hosts:
      - ${NAME}.naren4biz.in
    secretName: ${NAME}-tls              

EOF
k create -f ${NAME}.yaml -n ${NAME}

# Create the `finance.naren4biz.in` CRT


kubectl create secret generic ${NAME}-tls --from-file=tls.crt=${NAME}.crt --from-file=tls.key=${NAME}.key --from-file=ca.crt=ca.crt -n ${NAME}

```
# 2 - Create the `social.naren4biz.in` Application
```
NAME=social
k create ns ${NAME}
cat > ${NAME}.yaml <<EOF 
kind: Pod
apiVersion: v1
metadata:
  name: ${NAME}
  labels:
    app: ${NAME}
spec:
  containers:
  - name: ${NAME}
    image: hashicorp/http-echo:0.2.3
    args:
    - "-text=${NAME}"
---
kind: Service
apiVersion: v1
metadata:
  name: ${NAME}
spec:
  selector:
    app: ${NAME}
  ports:
  - port: 5678 
---

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${NAME}
spec:
  rules:
  - host: ${NAME}.naren4biz.in
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: ${NAME}
            port:
              number: 5678
  tls:
  - hosts:
      - ${NAME}.naren4biz.in
    secretName: ${NAME}-tls              

EOF
k create -f ${NAME}.yaml -n ${NAME}

# Create the `social.naren4biz.in` CRT

openssl req -new -newkey rsa:4096 -keyout ${NAME}.key -out ${NAME}.csr -nodes -subj '/CN=${NAME}'
openssl x509 -req -sha256 -days 365 -in ${NAME}.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out ${NAME}.crt
kubectl create secret generic ${NAME}-tls --from-file=tls.crt=${NAME}.crt --from-file=tls.key=${NAME}.key --from-file=ca.crt=ca.crt  -n ${NAME}

```
# 3 - Create the `technology.naren4biz.in` Application
```
NAME=technology
k create ns ${NAME}
cat > ${NAME}.yaml <<EOF 
kind: Pod
apiVersion: v1
metadata:
  name: ${NAME}
  labels:
    app: ${NAME}
spec:
  containers:
  - name: ${NAME}
    image: hashicorp/http-echo:0.2.3
    args:
    - "-text=${NAME}"
---
kind: Service
apiVersion: v1
metadata:
  name: ${NAME}
spec:
  selector:
    app: ${NAME}
  ports:
  - port: 5678 
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${NAME}
spec:
  rules:
  - host: ${NAME}.naren4biz.in
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: ${NAME}
            port:
              number: 5678
  tls:
  - hosts:
      - ${NAME}.naren4biz.in
    secretName: ${NAME}-tls              

EOF
k create -f ${NAME}.yaml -n ${NAME}

# Create the `technology.naren4biz.in` CRT

openssl req -new -newkey rsa:4096 -keyout ${NAME}.key -out ${NAME}.csr -nodes -subj '/CN=${NAME}'
openssl x509 -req -sha256 -days 365 -in ${NAME}.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out ${NAME}.crt
kubectl create secret generic ${NAME}-tls --from-file=tls.crt=${NAME}.crt --from-file=tls.key=${NAME}.key --from-file=ca.crt=ca.crt  -n ${NAME}


```

# Setup mTLS
Instruct the Server-App to Validate the Client CRT as well . 

# Enable the ingress to validate the incoming request 
```
NAME=finance
cat > ${NAME}-m-tls.yaml <<EOF 
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${NAME}
  annotations:
    nginx.ingress.kubernetes.io/auth-tls-verify-client: "on"
    nginx.ingress.kubernetes.io/auth-tls-secret: "${NAME}/${NAME}-tls"    
    nginx.ingress.kubernetes.io/auth-tls-error-page: "https://naren4biz.in/error.html"
    nginx.ingress.kubernetes.io/auth-tls-verify-depth: "1"
    nginx.ingress.kubernetes.io/auth-tls-pass-certificate-to-upstream: "true"  
spec:
  rules:
  - host: ${NAME}.naren4biz.in
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: ${NAME}
            port:
              number: 5678
  tls:
  - hosts:
      - ${NAME}.naren4biz.in
    secretName: ${NAME}-tls              

EOF
k apply -f ${NAME}-m-tls.yaml  -n ${NAME}

```
# Testing 
# Create the client crt
```
openssl req -new -newkey rsa:4096 -keyout client.key -out client.csr -nodes -subj '/CN=naren4biz'
openssl x509 -req -sha256 -days 365 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 02 -out client.crt

```

# FAILS:
```
curl -Lk https://finance.naren4biz.in
```
# PASSES:
```
curl -Lk --cacert ca.crt  --key client.key  --cert client.crt  https://finance.naren4biz.in
```
     
ref: 
- https://kubernetes.github.io/ingress-nginx/examples/auth/client-certs/ingress.yaml
- https://awkwardferny.medium.com/configuring-certificate-based-mutual-authentication-with-kubernetes-ingress-nginx-20e7e38fdfca

