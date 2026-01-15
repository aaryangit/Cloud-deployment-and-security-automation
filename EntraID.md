**Active Directory**

For the successful implementation of the project simulating an enterprise architecture an active directory is included.  
The EntraID is created and populated using MS Graph PowerShell.  

To start with this MS Graph Powershell is required which can be installed on the local device using the steps mentioned in this blog post:-  
`https://www.prajwaldesai.com/install-microsoft-graph-powershell-module/`

After installation you will get a prompt like this  

<img width="666" height="636" alt="image" src="https://github.com/user-attachments/assets/b55804cc-6b8b-49e2-979f-3aaacaac73d0" />  

Then after installation you can connect to Graph using local powershell using admin privileges by :-  
`Connect-MgGraph -Scopes "Group.ReadWrite.All","User.Read.All","RoleManagement.ReadWrite.Directory" `   
These are the scopes and permissions for the scopes  

As seen in the image below with the necessary parameters.  

<img width="1200" height="374" alt="image" src="https://github.com/user-attachments/assets/2c6c8297-05b9-40be-9060-2848b2cff998" />  

With the same Command similar users can be created  

<img width="1532" height="188" alt="image" src="https://github.com/user-attachments/assets/25c560a2-941c-4c69-8ed1-d67e972a18f5" />

Now all these Users can be added to a single group for the project or based on their teams. Make sure to make the group "unified"( That means its a MS 365 group).  

<img width="1433" height="466" alt="image" src="https://github.com/user-attachments/assets/5eafd10f-ea6f-4103-bf7e-c1b7aa71dd5f" />  
