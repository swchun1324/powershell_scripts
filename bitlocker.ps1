
$tpm_check = get-tpm
$ad_check = (dsregcmd /status | select-string "AzureADJoined : Yes")

if((Get-BitLockerVolume -MountPoint C:).encryptionpercentage -eq 0){
    write-host("Bitlocker is not enabled checking the settings...")
    
}else{
    write-host("Bitlocker is running... Exitting ...")
    Exit

}


function bitlocker(){
    
    try{
        manage-bde -on C: -skiphardwaretest -computername $env:Computername
        manage-bde -protectors -add C: -RecoveryPassword 
        $BLV = Get-BitLockerVolume -MountPoint $env:SystemDrive
        $keyprotectorID=""
        foreach($keyprotector in $BLV.KeyProtector){
            if($keyprotector.keyprotectortype -eq "Recoverypassword"){
                $keyprotectorID=$keyprotector.KeyprotectorId
                break;
            }
        
        }

        $result = BackupToAAD-BitLockerKeyProtector -MountPoint "$($env:SystemDrive)" -KeyProtectorId $keyprotectorID
        while((Get-BitLockerVolume -MountPoint C:).encryptionpercentage -ne 100){
            write-host("Running encryption")
            write-host("Please do not turn off the computer...")
            write-host("$((Get-BitLockerVolume -MountPoint C:).encryptionpercentage)%")
            sleep 30
        }
    
    }
    catch{
        manage
        write-host("Failed to do a bitlocker")
    
    }




}

if($tpm_check.tpmactivated -eq "True" -and $tpm_check.TpmEnabled -eq "True" -and $tpm_check.TpmOwned -eq "True"){
    if($ad_check -ne $null){
        write-host("It is azure ad joined")
        bitlocker
    }else{
        write-host("Trying to join azuread manually...")
        try{
            Write-Host("The user is not registered in the azure ad Joining...")
            dsregcmd /join /debug
            sleep 10
            write-host("Checking whether the current computer is joined to azure ad")
            if($ad_check -eq $null){
		Write-Host("Failed to join the azure ad")
                exit
            }else{
		bitlocker
            }
            
        
        }catch{
            write-host("Can not join the current azure ad... Can not proceed the operation..")
            exit
        
        }

    }
}   
else{
        write-host("TPM is not activated. Activate the tpm settings in the bios setting before you run the bitlocker encryption")
}
