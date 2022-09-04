$result = Test-Connection "www.example.org" -ErrorAction "SilentlyContinue";

if ($null -eq $result){
    write-host("The internet is not up yet..")
    start-sleep 10
    if(Test-Connection "www.example.org"){
        write-host("The internet is connected again")
    }
}

if((get-wulist).count -eq 0){
    powershell.exe -WindowStyle Maximized -executionpolicy bypass C:\powershell_scripts\package.ps1
}else{
    reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v InstallAgent /t REG_SZ /d 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle Maximized -ExecutionPolicy Bypass -File "C:\powershell_scripts\update.ps1' /f
    Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -ignorereboot
    restart-computer -force
}

