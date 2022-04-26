
# Setup ArgoCD value file for First Cluster
```
bash ../scripts/setup_argocd.sh 
```
![setup_argocd.PNG](../img/setup_argocd.PNG)

####  Install ArgoCD at First cluster 
```
bash ../scripts/install_argocd.sh 
```
![install_argocd.PNG](../img/install_argocd.PNG)

# Setup the Service Account at second/leaf for clusters (repeat for every cluster wants to controlled by Argocd)
```
bash ../scripts/setup_cluster.sh 

```
![setup_cluster.PNG](../img/setup_cluster.PNG)


# Add the cluster to argocd 
```
#kubectl cluster-info --context kind-blue
bash ../scripts/add_cluster_to_argocd.sh
```
![add_cluster_to_argocd.PNG](../img/add_cluster_to_argocd.PNG)

# Check the Green cluster 
![argocd.PNG](../img/argocd.PNG)

# Clean up  
![cleanup_argocd.PNG](../img/cleanup_argocd.PNG)