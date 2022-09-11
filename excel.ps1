#Retrieving hardware info from the owi computers
$username="###" #user credential for shared EX) owi\<user_name>
$password="###" | ConvertTo-SecureString -AsPlainText -Force #Change password for the shared drive credential
$credential = New-Object System.Management.Automation.PsCredential($username, $password) #credential
New-PSDrive -name share_data -Root \\owi-ws-g1-1\shared -Credential $credential -PSProvider FileSystem #file share location change \\<comp_name or ip>\<share location>

$outfile = "\\owi-ws-g1-1\shared\data.csv" # CSV File location 
$CPU_name = (Get-WmiObject -class Win32_Processor).name
$NVIDIA_NAME =  (Get-WmiObject Win32_VideoController | Where-Object{ $_.name -like "*NVIDIA*"}).name
$RAM = Get-WmiObject -Query "SELECT TotalVisibleMemorySize, FreePhysicalMemory FROM Win32_OperatingSystem"
$comp_name = $env:COMPUTERNAME
$totalRAM = [string][math]::Round($RAM.TotalVisibleMemorySize/1MB, 2) + "GB"
$bios_manufacturer = (Get-WmiObject Win32_BIOS).manufacturer
$bios_version = (Get-WmiObject Win32_BIOS).SMBIOSBIOSVersion
$motherboard_info = (Get-CimInstance -Class Win32_BaseBoard).Product
$month = (get-date).month
$lastlogonuser = (Get-WmiObject -class win32_process | Where-Object name -match explorer).getowner().user 
$lastlogdomain = (Get-WmiObject -class win32_process | Where-Object name -match explorer).getowner().domain

$lastlogon = $lastlogdomain + "/" + $lastlogonuser # checks the domain and the username
# it only shows the last logon user, which is creating a csv file.
#$comp_name = "hello-world"

if(Test-Path $outfile){
    $csvfile = import-csv $outfile
    foreach ($data in $csvfile){
        $months = (get-date $data.Date).month
        if($data.comp_name -eq $comp_name -and $months -eq $month){
            write-host("It exists")
            remove-PSDrive -Name share_data -Force
            exit
        }
    
    }
    $csvfile.Date = Get-Date
    $csvfile.comp_name = $comp_name
    $csvfile.CPU_NAME = $CPU_name
    $csvfile.RAM = $totalRAM
    $csvfile.Video_Card_name = $NVIDIA_NAME
    $csvfile.Bios_man = $bios_manufacturer
    $csvfile.bios_version = $bios_version
    $csvfile.motherboard_name = $motherboard_info
    $csvfile.lastlogon = $lastlogon
    $csvfile | Export-CSV $outfile -append

}else{
    $newcsv = {} | select "Date","COMP_NAME","CPU_NAME","RAM","Video_Card_Name","Bios_Man","Bios_version","Motherboard_name","lastlogon" | export-csv $outfile
    $csvfile = import-csv $outfile
    $csvfile.Date = Get-Date
    $csvfile.comp_name = $env:COMPUTERNAME
    $csvfile.CPU_NAME = $CPU_name
    $csvfile.RAM = $totalRAM
    $csvfile.Video_Card_name = $NVIDIA_NAME
    $csvfile.Bios_man = $bios_manufacturer
    $csvfile.bios_version = $bios_version
    $csvfile.motherboard_name = $motherboard_info
    $csvfile.lastlogon = $lastlogon
    $csvfile | Export-CSV $outfile
    Remove-PSDrive -Name share_data -Force

}

