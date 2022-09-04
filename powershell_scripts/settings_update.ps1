if ((get-packageprovider | where-object {$_.Name -like "*Nuget*" })){ write-host("Skipping Installation")}else{Install-packageprovider -name nuget -force}

if((Get-Module pswindowsupdate) -ne $null){write-host("It looks like the package is installed")}else{
Install-Module PSWindowsUpdate -Confirm:$False -force
start-sleep 3
Import-Module pswindowsupdate}

if(get-wuservicemanager | Where-Object { $_.ServiceID -eq "7971f918-a847-4430-9279-4a52d1efe18d" } ){Write-Host("The service is already enabled")}else{Add-WUServiceManager -ServiceID 7971f918-a847-4430-9279-4a52d1efe18d -Confirm:$false }
