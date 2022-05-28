# Install ingress controller 
- 1 Nginx 

```
wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

set the nodeSelector

      nodeSelector:
        kubernetes.io/hostname: demo-cluster-control-plane
```

- 2 HaproxyTech


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
     
ref: 
- https://kubernetes.github.io/ingress-nginx/examples/auth/client-certs/ingress.yaml
- https://awkwardferny.medium.com/configuring-certificate-based-mutual-authentication-with-kubernetes-ingress-nginx-20e7e38fdfca

