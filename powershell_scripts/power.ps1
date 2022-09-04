
powershell.exe -executionpolicy bypass C:\powershell_scripts\settings_update.ps1

Write-Host("Adding the ultimate performance power setting")


powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61


$p = Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan -Filter "ElementName = 'Ultimate performance'"
$guid = $p.InstanceID.split('\')[-1].trim('{}')
write-Host("The $guid is selected")
#get the guid of the ultimate performance and activate it.
powercfg /s $guid
write-host("Activating the power settings")


#hard disk time out failed
powercfg.exe -change -disk-timeout-ac 0 

# powershell usb selective disabled

powercfg /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
