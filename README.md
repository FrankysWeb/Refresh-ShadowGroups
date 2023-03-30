# Refresh-ShadowGroups
 Refresh Active Directory shadow groups with PowerShell
 
# Usage
 Modify these lines and create a OU to group mapping:
 
```
 $OUtoGroupList = @{
    "OU=OU1,OU=Benutzer,DC=frankysweblab,DC=de" = "ShadowGroup_OU1"
    "OU=OU2,OU=Benutzer,DC=frankysweblab,DC=de" = "ShadowGroup_OU2"
 }
 ```
 Run Refresh-ShadowGroups.ps1 with task sheduler

## Windows Server Versions
 - Windows Server 2016
 - Windows Server 2019
 - Windows Server 2022

## Website
 [FrankysWeb](https://www.frankysweb.de/)
