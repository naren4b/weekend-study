# Local minio setup e2e 

#### Deploy the minio server 
 - label the node 
```
nodeSelector:
 kubernetes.io/hostname: minio
```
 - create the data directory 

```
  volumes:
  - name: localvolume
    hostPath: # TODO 
      path: /mnt/disk1/data # TODO
      type: DirectoryOrCreate # TODO 
```

 - Deploy the workload 

```
k apply -f *.yaml
k get pod -n minio
k get svc -n minio
k get ing -n minio 

```
 - Open the console : 
  [console.minio.local](https://console.minio.local)

#### Minio Client (mc) 
```
ALIAS=k8s-minio-dev
URL=api-minio.local
ACCESS_KEY=accesskey
SECRET_KEY=secretkey
BUCKET_NAME=demo

mc alias set ${ALIAS} http://${URL} ${ACCESS_KEY} ${SECRET_KEY}
mc ls ${ALIAS}/${BUCKET_NAME}

```
ref: https://docs.min.io/minio/baremetal/quickstart/k8s.html
