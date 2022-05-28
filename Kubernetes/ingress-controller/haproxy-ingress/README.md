# Get a minikube cluster 
```
minikube start --driver=docker
```


#### Create a Kind k8s Cluster 
```
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
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
EOF
```

# Getting the latest chart 
```
bash get_haproxy-ingress_chart.sh

```


# Test install the haproxy 
```
CLUSTER_NAME=demo
bash install_haproxy-ingres.sh
kubectl port-forward -n ingress-controller svc/${CLUSTER_NAME}-haproxy-ingress 80 --address 0.0.0.0

kubect apply -f test/

# add `demo.haproxy.local` to your /etc/host file (windows: C:\Windows\System32\drivers\etc\hosts)
127.0.0.1 demo.haproxy.local
```
visit : http://demo.haproxy.local/



