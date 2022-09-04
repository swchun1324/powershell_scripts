$result = Test-Connection "www.example.org" -ErrorAction "SilentlyContinue";

if ($null -eq $result)
{
    write-host("Installing the network drive")
    C:\powershell_scripts\network_adapter\APPS\SETUP\SETUPBD\Winx64\SetupBD.exe /s
    Start-Sleep -Seconds 60
    if(Test-Connection "www.example.org"){
        write-host("The internet is connected again")
    
    }else{
        write-host("The internet is not set up.. please install maually")
    } 


}else{

    write-host("The internet is set up, so it will continue operation")
} 