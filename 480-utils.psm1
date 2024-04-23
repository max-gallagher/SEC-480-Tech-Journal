function 480Banner()
{
    Write-Host 
    "
    ░▒▓██████████████▓▒░ ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓█▓▒░▒▓█▓▒░        
    ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░   ░▒▓█▓▒░▒▓█▓▒░        
    ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░   ░▒▓█▓▒░▒▓█▓▒░        
    ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░░▒▓██████▓▒░       ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░   ░▒▓█▓▒░▒▓█▓▒░        
    ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░   ░▒▓█▓▒░▒▓█▓▒░        
    ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░   ░▒▓█▓▒░▒▓█▓▒░        
    ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░       ░▒▓██████▓▒░   ░▒▓█▓▒░   ░▒▓█▓▒░▒▓████████▓▒░ 
                                                                         
     "
}

function 480Connect([string] $server)
{
    $conn = $global:DefaultVIServer
    #are we already connected>
    if ($conn){
        $msg = "Already Connected to: {0}" -f $conn

        Write-Host -ForegroundColor Green $msg
    }else {
        $conn = Connect-VIServer -server $server
        #If this fails, let Connect-VIServer handle the exception
    }
}

function Get-480Config ([string] $config_path)
{
    Write-Host "Reading " $config_path
    $conf=$null
    if(Test-Path $config_path)
    {
        $conf = (Get-Content -Raw -Path $config_path | ConvertFrom-Json)
        $msg = "Using Configuration at {0}" -f $config_path
        Write-Host -ForegroundColor "Green" $msg
    }else {
        Write-Host -ForegroundColor "Yellow" "No Configuration"
    }
    return $conf
}    
#Lists all vms in the selected folder and allows you to pick which one you want to work with
function Select-VM([string] $folder)
{
    $selected_vm=$null
    try {
        $vms = Get-VM -Location $folder
        $index = 1
        Write-Host "Here are the vms in $folder :" -ForegroundColor Cyan
        foreach($vm in $vms)
        {
            Write-Host [$index] $vm.name
            $index+=1
        }
        $pick_index = Read-Host "Which index number [x] do you wish to pick?"
        $selected_vm = $vms[$pick_index -1]
        Write-Host "You picked" $selected_vm.name
        return $selected_vm
    }
    catch {
        Write-Host "Invalid Folder $folder" -ForegroundColor "Red"
    }    
}

# Disconnects you from your vsphere server once the script is done running
function 480Disconnect {
    $conn = $global:DefaultVIServer
    if ($conn) {
        Disconnect-VIServer -Server $conn -Confirm:$false
        Write-Host "Disconnected from $($conn.Name)" -ForegroundColor Green
} else {
    Write-Host "You are currently not connected to any servers." -ForegroundColor "Yellow"
}
}

# Lists all snapshots for your selected VM and allows you to chose one to use as a base snapshot for the cloning process
function select_snapshot([string] $vm)
{  
    $selected_ss=$null
    try {
        $snapshots = Get-Snapshot -vm $vm
        $index = 1
        Write-Host "Here are the snapshots for $vm :" -ForegroundColor Cyan
        foreach($snapshot in $snapshots)
        {
            Write-Host [$index] $snapshot.name
            $index+=1
        }
        $pick_index = Read-Host "Which index number [x] do you wish to pick?"
        $selected_ss = $snapshots[$pick_index -1]
        Write-Host "You picked" $selected_ss.name
        return $selected_ss
    }
    catch {
        Write-Host "Invalid snapshot" -ForegroundColor "Red"
    }    
}
#Lists your available datastores and allows you to select one
function select_datastore()
{

    $selected_ds=$null
    try {
        $datastores = Get-Datastore 
        $index = 1
        Write-Host "Here are your available datastores:" -ForegroundColor Cyan
        foreach($datastore in $datastores)
        {
            Write-Host [$index] $datastore.name
            $index+=1
        }
        $pick_index = Read-Host "Which index number [x] do you wish to pick?"
        $selected_ds = $datastores[$pick_index -1]
        Write-Host "You picked" $selected_ds.name
        return $selected_ds
        }
        catch {
            Write-Host "Invalid datastore $ds" -ForegroundColor "Red"
        }    
}
#Function used to list all of the hosts for your vsphere network and allow you to switch which one you want to use
function select_host ()
{
    $selected_host=$null
    try {
        $hosts = Get-VMHost
        $index = 1
        Write-Host "Here are your available hosts:" -ForegroundColor Cyan
        foreach($vmhost in $hosts)
        {
            Write-Host [$index] $vmhost.name
            $index+=1
        }
        $pick_index = Read-Host "Which index number [x] do you wish to pick?"
        $selected_host = $hosts[$pick_index -1]
        Write-Host "You picked" $selected_host.name
        return $selected_host
        }
        catch {
            Write-Host "Invalid host $vmhost" -ForegroundColor "Red"
        }    
}
#Function used to create a new linked clone
function New-LinkedClone {param([string] $VMName,[string] $SnapshotName,[string] $Datastore,[string] $VMHost)

    Write-Host "Your selected configurations are:" -ForegroundColor Cyan 
    Write-Host "VMName: $VMName"
    Write-Host "SnapshotName: $SnapshotName"
    Write-Host "Datastore: $Datastore"
    Write-Host "VMHost: $VMHost"

    $Skip = Read-Host "Do you want to create a linked clone? (Y/N)"
    if ($Skip -eq "Y") 
    {
        $NewVMName = Read-Host "What would you like to name the VM: "
        $linkedClone = "{0}.linked" -f $VMName
        try {
            $linkedVM = New-VM -LinkedClone -Name $linkedClone -VM $VMName -ReferenceSnapshot $SnapshotName -VMHost $VMHost -Datastore $Datastore
            $newVM = New-VM -Name $NewVMName -VM $linkedVM -VMHost $VMHost -Datastore $Datastore
            Write-Host "Linked clone and new VM created successfully." -ForegroundColor Green
            }
            catch {
                Write-Host "Error: $_" -ForegroundColor Red
            }
            if ($linkedVM) {
                $linkedVM | Remove-VM -Confirm:$false
                Write-Host "Linked clone removed." -ForegroundColor Green
            }
        }
    else {
        Write-Host ("Skipping Linked Clone Creation") -ForegroundColor Cyan
        }
}


# Function to create a Virtual Switch and Portgroup
function New-Network { param([string] $VMHost)
    try {
    Write-Host "VMHost: $VMHost"
    Write-Host("Starting to create a New Network")
    $switchName = Read-Host("What would you like to name the new switch?") 
    $newSwitch = New-VirtualSwitch -VMHost $VMHost -Name $switchName 
    $pgName = Read-Host("What would you like to name your new portgroup?") 
    New-VirtualPortGroup -VirtualSwitch $newSwitch -Name $pgName 
    Write-Host("Switch Created") -ForegroundColor Green
    Get-VirtualSwitch
    }
    catch {
        Write-Host "Error: $_" -ForegroundColor Red
    }
        
}
#Function to get VMs Name, Ip Address, and Mac Address
function Get-IP { param([string] $VMName)
    Write-Host("Here are is your information for that VM") -ForegroundColor Cyan
    $VM = Get-VM -Name $VMName
    $IPAddress = ($VM.Guest.IPAddress | Where-Object { $_ -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' })
    $NetAdapter = Get-NetworkAdapter -VM $VM
    $MACAddress = $NetAdapter.MacAddress
   
    Write-Host "VM Name: $VMName" -ForegroundColor Yellow
    Write-Host "MAC Address: $MACAddress" -ForegroundColor Yellow
    Write-Host "IP Address: $IPAddress" -ForegroundColor Yellow
   }

#Start and Stop

function PowerVM { param ([string] $VMNAME)
   $skipPower = Read-Host "Would you like to power on/off a VM? [y or n]"
   if ($skipPower -eq "Y" -or $skipPower -eq "y") 
   {
    $powerOpt = Read-Host "Would you like to turn the VM on or off?"
    if ($powerOpt -eq "on")
    {
        Start-VM $VMName
        Write-Host "$VMName has been started" -ForegroundColor Green
    }
    elseif ($powerOpt -eq "off") {
        Stop-VM $VMName
        Write-Host "$VMName has been stopped" -ForegroundColor Green
    }
    else {
        Write-Host ("invalid response, skipping power settings")
    } 
 }
    else {
        Write-Host ("Skipping VM Power Settings")
    }

 }

function Set-Network { param ([string] $VMName)
Get-NetworkAdapter $VMName
    $selectedAdapter=$null
        try {
            $adapters = Get-NetworkAdapter $VMName
            $index = 1
            Write-Host "Here are your available network adapters:" -ForegroundColor Cyan
            foreach($adapter in $adapters)
                {
                    Write-Host "[$index] $($adapter.Name)"
                    $index+=1
                }
                $pick_index = Read-Host "Which index number do you wish to pick?"
                $selectedAdapter = $adapters[$pick_index -1]
                Write-Host "You picked $($selectedAdapter.Name)"
                }
            catch {
                Write-Host "Invalid Adapter" -ForegroundColor "Red"
            }     
    $selectedVNetwork = $null
            try {
                $vNetworks = Get-VirtualNetwork
                $index = 1
                Write-Host "Here are your available virtual networks"
                foreach($vNetwork in $vNetworks)
                    {
                        Write-Host "[$index] $($vNetwork.Name)"
                        $index+=1
                    }
                    $pick_index = Read-Host "Which index number do you wish to pick?"
                    $selectedVNetwork = $vNetworks[$pick_index -1]
                    Write-Host "You picked $($selectedVNetwork.Name)"
                    Set-NetworkAdapter -NetworkAdapter $selectedAdapter -NetworkName $selectedVNetwork
                }
            catch {
                Write-Host "Invalid virtual network" -ForegroundColor "Red"
            }
            
    $changeAnother = Read-Host "Do you want to change another network adapter? (Y/N)"
        while ($changeAnother -eq 'Y') {
            try {
                $adapters = Get-NetworkAdapter $VMName
                $index = 1
                Write-Host "Here are your available network adapters:" -ForegroundColor Cyan
                foreach($adapter in $adapters)
                    {
                        Write-Host "[$index] $($adapter.Name)"
                        $index+=1
                    }
                    $pick_index = Read-Host "Which index number do you wish to pick?"
                    $selectedAdapter = $adapters[$pick_index -1]
                    Write-Host "You picked $($selectedAdapter.Name)"
                }
            catch {
                    Write-Host "Invalid Adapter" -ForegroundColor "Red"
                }    
            try {
                    $vNetworks = Get-VirtualNetwork
                    $index = 1
                    Write-Host "Here are your available virtual networks"
                    foreach($vNetwork in $vNetworks)
                    {
                        Write-Host "[$index] $($vNetwork.Name)"
                        $index+=1
                    }
                    $pick_index = Read-Host "Which index number do you wish to pick?"
                    $selectedVNetwork = $vNetworks[$pick_index -1]
                    Write-Host "You picked $($selectedVNetwork.Name)"
                    Set-NetworkAdapter -NetworkAdapter $selectedAdapter -NetworkName $selectedVNetwork
                }
            catch {
                    Write-Host "Invalid virtual network" -ForegroundColor "Red"
                }        
                $changeAnother = Read-Host "Do you want to change another network adapter? (Y/N)"
                }
            }


 