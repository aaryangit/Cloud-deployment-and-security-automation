# Cloud-deployment-and-security-automation

This Project is a working Demonstration of Azure Infrastruture Implementation with a focus on automation and quick implementation of resources using Azure Native platforms including:-  
**- Azure Graph powershell**  
**- Azure CLI**   
**- BICEP templates**  
**- VSCode (not mandatory but highly recommend for its seamless integration with Azure)**

The BICEP templates are optimised and structured, focused on having a modular code and ease of deployment for environment needing duplicity of the resources.

Securing the deployed resources in the environment is also a priority with various features included in the BICEP templates which will be explained further.

The project has 1 master file named - MainProject which combines all the modules of the project, where each module focuses on 1 single task (eg:- VM creation, Implementing policies, creating Keyvault or storage account, etc.) 

The Following screenshot visualises the architecture of the deployment using VSCode's inbuilt Visualizer. 

<img width="1562" height="1033" alt="image" src="https://github.com/user-attachments/assets/d09746fd-5b04-40eb-b922-1ecc4d5722fc" />  

The Security Implementation in Project are as follows: -  

1. The Virtual Machines Created have just one port open which RDP 3389 that too is accsible only Azure Bastion which acts a jump server. The VM has no Public IP address.  
2. Storage Account created is encrypted using CMKs stored in AzureKeyVault.
3. Only Secure transfer is allowed for the Storage Account and that is also included in the Policies for future deployments.  
4. For the Virtual Machines deployed, Azure Monitoring Agent(AMA) is installed for log collection and also for Automated OS patch Management using Azure policy.  
5. A Dedicated Log Analytics Workspace (LAW) is setup to collect all the diagnostic logs from the VMs using Custom Data Collection Rules (DCR).
6. Policies implementing uniformity and ease of documentation like 'Tagging' and 'Uniformity of location' is implemented as well.

