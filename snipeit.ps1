param (
    [switch]$clean = $false
    
)
Install-Module SnipeitPS -Confirm:$false -force
Import-Module SnipeitPS

$comp_name = $env:COMPUTERNAME
$company_name = "*offworld*"


#$assetExists = Get-Asset -search $comp_name -url $url -apikey $apikey

$manufacturer_name = (gwmi win32_computersystem).manufacturer


function check($name){

    if($name -eq "laptop"){

        $laptop_lists = @("thinkpad", "legion","razor","gamepad","asus")
        $model = wmic computersystem get model
        write-host("Laptop")
    
    }
    if($name -eq "G1"){
    
        write-host("Gen1")
    }
    if($name -eq "G2"){
    
        write-host("Gen2")
    }
    if($name -eq "G3"){
    
        write-host("Gen3")
        $version_lists = @("*asus*","*MSI*")
    }
    if($name -eq "G4"){
    
        write-host("Gen4")
    }

}

$laptop_lists = @("thinkpad", "legion","razor","gamepad","asus")
foreach($laptops in $laptop_lists){
    write-host($laptops)
}



$version = $comp_name.split("-")[-2]


check($version)


if($clean){
    write-host("hello")

}else{

    write-host("It is not set up for automatic installation")
}