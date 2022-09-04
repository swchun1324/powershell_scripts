gpupdate /force


reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v InstallAgent /t REG_SZ /d 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "C:\set_remove.ps1' /f



Restart-Computer -force