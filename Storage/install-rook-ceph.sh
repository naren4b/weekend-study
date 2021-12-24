mkdir rook-ceph
cd rook-ceph/
 
helm repo add rook-release https://charts.rook.io/release
helm fetch rook-release/rook-ceph --untar

cd rook-ceph/
helm template naren-rook-ceph . -f values.yaml -n rook-ceph>naren-rook-ceph.yaml

kubectl create ns rook-ceph
kubectl apply -f naren-rook-ceph.yaml -n  rook-ceph
kubectl get -f naren-rook-ceph.yaml

wget https://raw.githubusercontent.com/rook/rook/release-1.8/deploy/examples/cluster-test.yaml
kubectl create -f cluster-test.yaml -n rook-ceph
kubectl get pod -n rook-ceph

wget https://raw.githubusercontent.com/rook/rook/release-1.8/deploy/examples/toolbox.yaml
kubectl create -f toolbox.yaml -n rook-ceph
kubectl get pod -n rook-ceph

kubectl -n rook-ceph logs -l app=rook-ceph-operator -f

mkdir test
cd test 

wget https://raw.githubusercontent.com/rook/rook/release-1.3/cluster/examples/kubernetes/ceph/csi/rbd/storageclass-test.yaml
wget https://raw.githubusercontent.com/rook/rook/release-1.3/cluster/examples/kubernetes/ceph/csi/rbd/pod.yaml
wget https://raw.githubusercontent.com/rook/rook/release-1.3/cluster/examples/kubernetes/ceph/csi/rbd/pvc.yaml

cd ..

kubectl appy -f test/


#https://www.youtube.com/watch?v=dA29dIK6g5o&ab_channel=CNCF%5BCloudNativeComputingFoundation%5D
#https://www.youtube.com/watch?v=brXPQ1Qwjl4&ab_channel=ShareLearn 
