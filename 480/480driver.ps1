Import-Module '480-utils' -Force
#Call Banner
480Banner
$conf =Get-480Config -config_path = "/home/max/480/480.json"
480Connect -server vcenter.max.local
Write-Host "Selecting your VM"
$selected_vm = Select-VM -folder "PROD"
$selected_snapshot = select_snapshot -vm $selected_vm
$selected_datastore = select_datastore
$selected_host = select_host
New-LinkedClone -VMName $selected_vm -SnapshotName $selected_snapshot -NewVMName $NewVMName -Datastore $selected_datastore -VMHost $selected_host
#New-Network -VMHost $selected_host
#Get-IP -VMName $selected_vm
#Set-Network -VMName $selected_vm
#PowerVM -VMName $selected_vm
#480Disconnect