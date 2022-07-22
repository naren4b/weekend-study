```
kubectl get pods -A -o custom-columns=NAME:.metadata.name,NS:.metadata.namespace,IMAGE:.spec.containers[].image |awk '{print $3 }'  | xargs -I {}  echo trivy image {} 
```
