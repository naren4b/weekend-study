# Vault
![image](https://user-images.githubusercontent.com/3488520/152898200-57a18b69-282d-4f07-8070-f425f6c67080.png)

_References :_  
- https://www.youtube.com/watch?v=VYfl-DpZ5wM&t=29&ab_channel=HashiCorp
- https://shapeshed.com/hashicorp-vault-ldap/
- https://learn.hashicorp.com/tutorials/vault/oidc-auth?in=vault/auth-methods
- https://www.burgundywall.com/post/hashicorp-vault-and-freeipa
# Brief
## Types of Secrets 
1. Secret Management 
2.  Authentication / Authrization System
3.   Username/Password 
4.   DB credentials 
5.   Api token
6.   tls certificate
## What we want to know 
1. Who has access to them 
2. Who has been using these 
3. How we can periodically rotate these 
## State of practice in real world  
### 1. Sprawling :  
- They are in plain text hard-coded in our source code (may be in the header)
- Inside Configuration Management System(chef/puppet/ansible) It can present where anyone has login can see them 
- Source Code Management System (git/gitlab)
### 2. Application can do terrible things to the secrets(Static Secrets), They are poor in keeping the secrets as secrets  
- It may print the credentials to the logging system (i.e Splunk , Elastic, Stdout etc)
- Diagnostic output(stacktrace/error report)
- Monitoring system 
### 2. How do application protect their own data(not the secret) while storing the information with REST 
 - So people can store the encryption key at Vault and they can grab the encrypt their data and store it in DB
 - Subtle nuances are their which application do it correctly  
## Challenges
- We don't know who has the access inside the organization 
- Can they login to github and access to see the credentials (i.e DB)
- If they could do it then we don't who did it (No audit trail to tell that )
- If they do it then we has no easy way to change the password or prevent such activity to rotate it periodically 
- Encrypting the data and store in the DB in an Multi-tenant System(i.e DB) 

## Solution for the Sprawling issue by Vault  
- Vault stores the Secrets in a central system 
- Vault encrypts both while it is stored and while transit between the Vault and any of the client who has to access this 
- Access Control System 
- Audit Control System

## Solution for the Application managing the secret by Vault  
- Dynamic secrets are generated after each interval 
- Ephemeral passwords even if the password is leaked it will not be valid for x amount of time
- Unique Credentials to each client . So as to identified the client who is using it 
- Revoke if it has been compromised the client access will be Revoked 

# Solution for Encrypting the data 
- Rather than handing over the encryption key to Application Vault provides Encrypt as a Service
- It provides named keys 
- Vault provides High level APIs to do cryptography encrypt/decrypt/sign/verify the key 
  - Encryption done properly(opensource , industry standard) 
  - No one sees the key 
  - Offload key management 

![image](https://user-images.githubusercontent.com/3488520/152898262-c2f42f01-e895-4886-9b89-8965ecf3c2d1.png)



![image](https://user-images.githubusercontent.com/3488520/152898376-2ad99cbd-0fc6-4f51-a68a-9daa825a5256.png)


