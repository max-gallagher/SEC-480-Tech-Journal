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


function 480Disconnect {
    $conn = $global:DefaultVIServer
    if ($conn) {
        Disconnect-VIServer -Server $conn -Confirm:$false
        Write-Host "Disconnected from $($conn.Name)" -ForegroundColor Green
} else {
    Write-Host "You are currently not connected to any servers." -ForegroundColor "Yellow"
}
}


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

function New-LinkedClone {param([string] $VMName,[string] $SnapshotName,[string] $Datastore,[string] $VMHost)
    
    Write-Host "VMName: $VMName"
    Write-Host "SnapshotName: $SnapshotName"
    Write-Host "Datastore: $Datastore"
    Write-Host "VMHost: $VMHost"

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



