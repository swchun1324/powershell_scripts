$pkglocation = split-path -parent $MyInvocation.MyCommand.path
$installation_location = "$pkglocation\installation_files"

set-location $installation_location

$nw_laptop = $env:COMPUTERNAME

$match = select-string "laptop" -InputObject $nw_laptop

if($match -ne $null){
    write-host("This is a laptop! Installing a zscaler")
    Start-Process -FilePath ".\Zscaler-windows-3.4.0.124-installer.exe" -wait -ArgumentList "--mode unattended"
    write-host("Zscaler Installation is Done. Continuing...")
}


Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install -y 7zip googlechrome firefox slack python discord notepadplusplus zoom vlc --ignore-checksums
 
start-process -Wait -FilePath msiexec.exe -ArgumentList /i, "GoToAssist_Remote_Support_Unattended.msi", /quiet, /qn, /norestart

reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v InstallAgent /t REG_SZ /d 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "C:\powershell_scripts\gpupdate.ps1' /f

powershell.exe -executionpolicy bypass C:\powershell_scripts\nvidia.ps1
powershell.exe -executionpolicy bypass C:\powershell_scripts\join_domain.ps1
powershell.exe -executionpolicy bypass C:\powershell_scripts\reboot.ps1
restart-computer -force




# installs the gotoassist package

#.\parsec-windows.exe /silent

#.\brave_installer-x64.exe --install --silent --system-level


#Stop-Transcript

#C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass Z:\update.ps1



# installs the parsec applcation
