ref: 
 - https://www.fadhil-blog.dev/blog/rancher-local-path-provisioner/

#### Step-1: Installation Local Path Provisioner
```
kubectl apply -f https://raw.githubusercontent.com/rancher/local-p/ath-provisioner/master/deploy/local-path-storage.yaml

```

#### Step-2 Create Test PVC
```
kubectl create -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/examples/pvc.yaml

```
#### Step-3 Create a Test Ppd
```
kubectl create -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/examples/pod.yaml

```
#### Step-4 Check the pv get created automatically 
```
kubectl get pv
kubectl get pvc
kubectl exec volume-test -- sh -c "echo local-path-test > /data/test"
kubectl exec volume-test -- sh cat /data/test

ssh <kubernetes node ip>
$ ls /var/lib/rancher/k3s/storage/

```
