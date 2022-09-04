

$lists = @("DefaultUsername",'DefaultPassword','AutoAdminLogon','logoncount')


$registrypath = $registrypath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$key = get-item -LiteralPath $registrypath


function test_reboot{
    if(test-path C:\powershell_scripts\reboot.txt){
            write-host("Continuing operation")        
        
        }else{
            write-host("Creating a reboot tasks")
            "1" | Out-File -FilePath C:\powershell_scripts\reboot.txt
        }

}






function checkreg($value){
    

    if($value -eq "DefaultUsername"){
        if($key.GetValue($value) -eq "owihelpdesk"){
            write-host("Good to go")
        }else{
             test_reboot
             reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d owihelpdesk /f
             
        }
    
    }
    
    if($value -eq "DefaultPassword"){
        if($key.GetValue($value) -eq "Once Upon A Time 6^"){
            write-host("Good to go")
            
        }else{
             test_reboot
             reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "Once Upon A Time 6^" /f
             
        }
    
    }
    
    if($value -eq "AutoAdminLogon"){
        if($key.GetValue($value) -eq 1){
            write-host("Good to go")
            
        }else{
             test_reboot
             reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon  /t REG_SZ /d 1 /f
             
        }
    
    }
        
    if($value -eq "logoncount"){
        if($key.GetValue($value) -ne 0){
            write-host("Good to go")
            
        }else{
             test_reboot
             reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v logoncount /t REG_SZ /d 10 /f
                  
        }
    
    }

}


function reboot_type($value){

    
    if($value -eq "DefaultUsername"){
       
       reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d owihelpdesk /f

    }
    
    if($value -eq "DefaultPassword"){
        
        reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "Once Upon A Time 6^" /f
             
    }
    
    if($value -eq "AutoAdminLogon"){
       
             reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon  /t REG_SZ /d 1 /f
             
        
    
    }
        
    if($value -eq "logoncount"){
        
             reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v logoncount /t REG_SZ /d 10 /f    
    }



}






foreach($value in $lists){
    if ($key.getValue($value, $null) -ne $null){

        checkreg($value)
    }else{
        test_reboot
        reboot_type($value)
    }


}

if(test-path C:\powershell_scripts\reboot.txt){
    write-host("Restarting required")
    remove-item C:\powershell_scripts\reboot.txt
    restart-computer
}else{
    write-host("No errors found with the auto login features")

}
