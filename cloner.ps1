# Max Gallagher Cloner Script                                                                               ./copier.ps1                                                                                                 
# Prompt user to input VM name
Write-Host "Available VMs: "
Get-VM | Select-Object -ExpandProperty Name
$VMName = Read-Host "Enter the name of the VM:"
$vm = Get-VM -Name $VMName

# Prompt user to select a snapshot
Write-Host "Available snapshots for VM $VMName :"
Get-Snapshot -VM $VMName | Select-Object -ExpandProperty Name
$SnapshotName = Read-Host "Enter the name of the snapshot"

# Prompt user to select a VMHost
Write-Host "Available VMHosts:"
Get-VMHost | Select-Object -ExpandProperty Name
$VMHost = Read-Host "Enter the name of the VMHost"

# Prompt user to select a Datastore
Write-Host "Available Datastores:"
Get-Datastore | Select-Object -ExpandProperty Name
$Datastore = Read-Host "Enter the name of the Datastore"

# Prompt user to input new VM name
$NewVMName = Read-Host "Enter the name of the new VM"

# Define linked clone name
$linkedClone = "{0}.linked" -f $VMName

# Get VMHost by name or IP address
$vmhost = Get-VMHost -Name $VMHost

# Get Datastore by name
$ds = Get-Datastore -Name $Datastore

# Get snapshot by name
$snapshot = Get-Snapshot -VM $vm -Name $SnapshotName

# Create linked clone
$linkedVM = New-VM -LinkedClone -Name $linkedClone -VM $vm -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $ds

# Create new VM based on the linked clone
$newVM = New-VM -Name $NewVMName -VM $linkedVM -VMHost $vmhost -Datastore $ds

# Remove the linked clone
$linkedVM | Remove-VM




