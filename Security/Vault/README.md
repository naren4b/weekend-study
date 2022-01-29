# Vault on Kubernetes Deployment Guide

## References :  https://www.youtube.com/watch?v=VYfl-DpZ5wM&t=29&ab_channel=HashiCorp

 1: 
 
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
a.  They are in plain text hard-coded in our source code (may be in the header)
b.  Inside Configuration Management System(chef/puppet/ansible) It can present where anyone has login can see them 
c.  Source Code Management System (git/gitlab)
### 2. Application can do terrible things to the secrets(Static Secrets), They are poor in keeping the secrets as secrets  
   a. It may print the credentials to the logging system (i.e Splunk , Elastic, Stdout etc)
   b. Diagnostic output(stacktrace/error report)
   c. Monitoring system 
### 2. How do application protect their own data(not the secret) while storing the information with REST 
   a. So people can store the encryption key at Vault and they can grab the encrypt their data and store it in DB
   b. Subtle nuances are their which application do it correctly  


## Challenges
1. We don't know who has the access inside the organization 
2. Can they login to github and access to see the credentials (i.e DB)
3. If they could do it then we don't who did it (No audit trail to tell that )
4. If they do it then we has no easy way to change the password or prevent such activity to rotate it periodically 
5. Encrypting the data and store in the DB in an Multi-tenant System(i.e DB) 

## Solution for the Sprawling issue by Vault  
1. Vault stores the Secrets in a central system 
2. Vault encrypts both while it is stored and while transit between the Vault and any of the client who has to access this 
3. Access Control System 
4. Audit Control System

## Solution for the Application managing the secret by Vault  
1. Dynamic secrets are generated after each interval 
2. Ephemeral passwords even if the password is leaked it will not be valid for x amount of time
3. Unique Credentials to each client . So as to identified the client who is using it 
4. Revoke if it has been compromised the client access will be Revoked 

# Solution for Encrypting the data 
1. Rather than handing over the encryption key to Application Vault provides Encrypt as a Service
2. It provides named keys 
3. Vault provides High level APIs to do cryptography encrypt/decrypt/sign/verify the key 
    a. Encryption done properly(opensource , industry standard) 
    b. No one sees the key 
    c. offload key management 

