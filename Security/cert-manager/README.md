# Create the cluster 

```
kind create cluster --name certmanager --image kindest/node:v1.19.1
```
https://www.haproxy.com/blog/use-helm-to-install-the-haproxy-kubernetes-ingress-controller/

# Install haproxytech
```
helm repo add haproxytech https://haproxytech.github.io/helm-charts
helm repo update
helm install \
      haproxy-ingresscontroller haproxytech/kubernetes-ingress  \
	  --namespace haproxy-ingresscontroller \
	  --create-namespace \
      --set controller.ingressClassResource.default=true \
	  --set controller.kind=DaemonSet \ 
	  --set controller.daemonset.useHostPort=true \
	  --set installCRDs=true 
```	  
or 
```
helm install       haproxy-ingresscontroller haproxytech/kubernetes-ingress     --namespace haproxy-ingresscontroller           --create-namespace       --set controller.ingressClassResource.default=true         --set controller.kind=DaemonSet   --set controller.daemonset.useHostPort=true  --set installCRDs=true	  
```	  
	  
# Check 
```
Kubectl get pod -n haproxy-ingresscontroller
```

# Install cert-manager
```
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.7.1 \
  --set installCRDs=true
  
```

# check 
```
kubectl get pod -n cert-manager

```
# Test application the ingress  
```
kubectl apply -f https://netlify.cert-manager.io/docs/tutorials/acme/example/deployment.yaml
kubectl apply -f https://netlify.cert-manager.io/docs/tutorials/acme/example/service.yaml
kubectl create --edit -f https://netlify.cert-manager.io/docs/tutorials/acme/example/ingress.yaml # update the ingress + ingress class and cert-manager annotation
```
####### sample #########
```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: haproxy
  name: kuard
  namespace: default
spec:
  rules:
  - host: naren4biz.in
    http:
      paths:
      - backend:
          serviceName: kuard
          servicePort: 80
        path: /
        pathType: Prefix
  tls:
  - hosts:
    - naren4biz.in
    secretName: naren4biz-tls
```
# Check Ingress 
```
kubectl get ing kuard
```
# Test ingress
``` 
kubectl run curl --image=radial/busyboxplus:curl -i --tty
curl -kivL -H 'Host: www.naren4biz.in' 'https://<node-ip>'
```
# Install for certficates
```
kubectl create --edit -f https://cert-manager.io/docs/tutorials/acme/example/staging-issuer.yaml
```
####### sample #########
```
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-prod
  namespace: default
spec:
  acme:
    email: naren@nokia.com
    preferredChain: ""
    privateKeySecretRef:
      name: letsencrypt-prod
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - http01:
        ingress:
          ingressTemplate:
            metadata:
              annotations:
                haproxy.org/ingress.class: haproxy
				
```
```
kubectl create --edit -f https://cert-manager.io/docs/tutorials/acme/example/ingress-tls.yaml
```
####### sample #########
```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    cert-manager.io/issuer: letsencrypt-prod
    kubernetes.io/ingress.class: haproxy
  name: kuard
  namespace: default
spec:
  rules:
  - host: naren4biz.in
    http:
      paths:
      - backend:
          serviceName: kuard
          servicePort: 80
        path: /
        pathType: Prefix
  tls:
  - hosts:
    - naren4biz.in
    secretName: naren4biz-tls
```

```
kubectl get certificate
kubectl get secret 
kubectl get challenges
kubectl get orders
```

ref: 
	- https://www.haproxy.com/blog/use-helm-to-install-the-haproxy-kubernetes-ingress-controller/
	- https://cert-manager.io/docs/tutorials/acme/nginx-ingress/
	- https://kind.sigs.k8s.io/docs/user/quick-start/








