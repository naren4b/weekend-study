# Continuos Integration 
_wiki_:

     In software engineering, continuous integration (CI) is the practice of merging all developers' working copies to a shared mainline several times a day.
_Characteristic_:

    - pushed to mainline frequently 
    - Automated Pipeline to build , package
    - Automated test(partial)
    - Use PR to review (PR are not CI if not merged fast )
    - If any of the automated test fails then that has the highest priority to be fixed
    - CI tools just orchestrates the various automation
    - CI mainly focuses to merge the code to mainline 

# Continuos Delivery
_Characteristic_:

    - Fully automated until production release ready waiting to be deployed in production 
    - Everything in this step is fully automated except the decision of promote the release in production 
    - This gives all the automation process is trusted 
    - It is an extension to ci , it is not CI 
    - Every green build is deployable to production 
    - End of the process it is a business decision to deploy a build or not , it is no more a technical decision 


# Continuos Deployment 
_Characteristic_:

    - This gives an ability to Management to take the decision to deploy any green build by just clicking a button ! 
    
