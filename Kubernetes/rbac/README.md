# Creating Kubernetes Users and Groups
ref: 
- https://learnk8s.io/rbac-kubernetes
- https://kubernetes-tutorial.schoolofdevops.com/configuring_authentication_and_authorization/


### Generate the user's private key
```
mkdir -p  ~/.kube/users
cd ~/.kube/users

openssl genrsa -out naren.key 2048

```
#### Generate Certification Signing Request (CSR) 
```
openssl req -new -key naren.key -out naren.csr -subj "/CN=naren/O=dev/O=example.org"
```
### Choose out of two options 
### Option 1 (if you have access to CA files )
#### Understand the CA key and CA pem file of kubernetes 
```
ls /etc/kubernetes/pki 
# Certificate : ca.crt (kubeadm) , Private Key : ca.key (kubeadm) 
# file /etc/kubernetes/pki/ca.crt
# ca.pem: PEM certificate
# file /etc/kubernetes/pki/ca.key
# ca-key.pem: PEM RSA private key
```
# Sign xthe csr with kubernetes cluster CA
```
openssl x509 -req -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -days 730 -in naren.csr -out naren.crt

```
### Option 2 (If you are admin of cluster )

```
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: naren-csr
spec:
  request: <copy-CSR-file-content>
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 8640000  # 100 days
  usages:
  - client auth
EOF

kubectl get csr
kubectl certificate approve naren-csr
kubectl get csr naren-csr -o jsonpath='{.status.certificate}'| base64 -d > naren.crt

```

# Set kubectl 
```
kubectl config set-credentials naren --client-certificate=/root/.kube/users/naren.crt --client-key=/root/.kube/users/naren.key
kubectl config get-contexts
kubectl config set-context <ctx-name> --cluster=<cluster-name>  --user=naren --namespace=<desired-namespace>
kubectl config view


```
