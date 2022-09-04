$p = Get-Process  -Id $pid | select -Expand id  # -Expand selects the string from the object id out of the current process.
Write-Host $p
$BJName = "Clean-up-script"   #Define Background job name

$startTime = (Get-Date) # set start time

$expiration = (Get-Date).AddMinutes(1)#program expires at this time
# you could change the expiration time by changing (Get-Date).AddSeconds(20) to (Get-Date).AddMinutes(10)or to hours or whatever you like


#-----------------
#Timer update function setup
function UpdateTime
   {
    $LeftMinutes =   ($expiration) - (Get-Date) | Select -Expand minutes  # sets minutes left to left time
    $LeftSeconds =   ($expiration) - (Get-Date) | Select -Expand seconds  # sets seconds left to left time
    
    }

    #get background job info and remove the it afterwards + print info
function BJManager   
    {
       Receive-Job -Name $BJName  #recive background job results
       Remove-Job -Name $BJName -Force #remove job
       Write-Host "Retrieving Background-Job info and Removing Job..."

    }
#-----------------
$ScriptLocation = "C:\powershell_scripts\settings_update.ps1"  #change this Var for different kind of script locations

Start-Job -Name $BJName -FilePath $ScriptLocation #start this script as background job
# dont start job in the loop.
do{   #start loop

   Write-Host "Working"#start doing other script stuff
   Start-Sleep -Milliseconds 5000  #add delay to reduce spam and processing power
   UpdateTime #call upadate function to print time

   Get-Job -Name $BJName  | select Id, State ,Location , Name
        if((Get-Job).State -eq "Failed")
            {
                BJManager
            }
         elseif((Get-Job).State -eq "Completed")
            {
                BJManager
                break
            }

 }
until ($p.HasExited -or (Get-Date) -gt $expiration) #check exit time

Write-Host "Timer Script Finished"
Get-Job -Name $BJName  | select Id, State ,Location , Name
UpdateTime

BJManager

if (-not $p.HasExited) { Stop-Process -ID $p -PassThru ; } 