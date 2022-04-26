# Install argocd in cluster 

#### FOR THE VERY FIRST TIME 
```
bash install_argocd.sh generate <dc-name>
```
![install_argocd_generate.PNG](img/install_argocd_generate.PNG)
####  Fix the value file or existing value file use this command 
```
bash install_argocd.sh template <dc-name>
```
![install_argocd_template.PNG](img/install_argocd_template.PNG)

# Setup the target clusters
```
setup_cluster.sh

```
![setup_cluster.PNG](img/setup_cluster.PNG)
# Add the cluster to argocd 
```
bash add_cluster_to_argocd.sh

```
![add_cluster_to_argocd.PNG](img/add_cluster_to_argocd.PNG)