# Trunk-Based development
![TBD](https://images.prismic.io/launchdarkly/7ad744e0-5c46-4a2f-b08d-6013a95e89c5_TrunkBasedDev-02+%283%29.png?auto=compress,format)
  - Single main branch 
  - Individual developer commits there code to the main branch anytime 
  - High Team maturity
    - Must be getting deployed automatically  
    - Should have good code coverage
    - Content must be well tested 
  - *Feature Toggles*  (Half baked features are not visible to the end user)
  - This is purely continuos Deployment 
  - It is simple and straight forward way have merging 
   
# Feature branches or GitHub Flow
![feature-branching-image](https://docs.microsoft.com/en-us/azure/devops/repos/git/media/branching-guidance/featurebranching.png?view=azure-devops)
  - One branch per feature 
  - Short delivery cycles 
  - It is Continuos Delivery 
  - Individual user(developer) makes multiple push to the feature branch 
  - PR(Pull Request) is used for merging the code to main after approve and review 
  - It is mildly complex stratergy 
  - Only the code team/Maintainers holds the write permission to the repo for others it is only read or fork the repo 


# Forking strategy
  - Fork the whole repositories 
  - Complete the work in the forked repo (all most like Feature Branch strategy )
  - Mostly used in Open-Source projects 
  - Same complexity level as that of Feature branching-strategy

# Release branches
![releasebranching_release](https://docs.microsoft.com/en-us/azure/devops/repos/git/media/branching-guidance/releasebranching_release.png?view=azure-devops)
  - One branch per release 
  - Relatively Longer cycle Merge compare to feature branch 
  - Complexity high while merging for different release branches 
  - delayed integration , no continuos integration 
  - Support previous release 
  - Sometime dedicated team/persons involved to merge the code 
# Git Flow
  - Lot and lot of branches 
  - one dev from there bunch of feature branches 
  - Complexity high while merging for different release branches 
  - Sometime dedicated team/persons involved to merge the code   
# Environment branches
  - Environment branches for each env on top of all other branches 
  - Everything get merged to everywhere 
  - This strategy doesn't understand we never deploy source code to any environment we deploy releases and that gets deployed to env
  - High Complexity 


_ref_: 
 - _1.https://docs.microsoft.com/en-us/azure/devops/repos/git/git-branching-guidance?view=azure-devops_
 - _2.https://dev.to/arbitrarybytes/comparing-git-branching-strategies-dl4_
 - _3.https://launchdarkly.com/blog/git-branching-strategies-vs-trunk-based-development/_
