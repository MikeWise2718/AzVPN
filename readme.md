# Powershell script for VPN manipulation



# Open an admin shell (right click on Powershell and select "run as administrator"
Get-ExecutionPolicy
set-executionpolicy Bypass

# Install azure module
Install-Module -Name Az.Resources -AllowClobber -Scope CurrentUser

# Login
 Connect-AzAccount -TenantId ee815d31-c338-4f38-85c2-6d11c3ccc14a
 Connect-AzAccount -TenantId ee815d31-c338-4f38-85c2-6d11c3ccc14a -AccountId mwise@microsoft.com
 Connect-AzAccount  -UseDeviceAuthentication 
 Connect-AzAccount  -TenantId 16b3c013-d300-468d-ac64-7eda0820b6d3 -AccountId mwise@microsoft.com
 (the last one worked using edge and having logged into the portal already with edge- after using the UseDeviceAuthentication)
 (see screenshot LoginWorked.png)
 aka.ms/mydevice
 aks.ms/totalrewards
  aks.ms/msfasetup