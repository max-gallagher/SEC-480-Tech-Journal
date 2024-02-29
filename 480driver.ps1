Import-Module '480-utils' -Force
#Call Banner
480Banner
$conf =Get-480Config -config_path = "/home/max/480/480.json"
480Connect -server $conf.vcenter_server
Write-Host "Selecting your VM"
$selected_vm = Select-VM -folder "BaseVM"
$selected_snapshot = select_snapshot -vm $selected_vm
$selected_datastore = select_datastore
$selected_host = select_host
Write-Host "Your selected configurations are:" -ForegroundColor Cyan -NoNewline 
Write-Host "
VM: $selected_vm 
Snapshot: $selected_snapshot
Datastore: $selected_datastore
Host: $selected_host
" -ForegroundColor White
New-LinkedClone -VMName $selected_vm -SnapshotName $selected_snapshot -NewVMName $NewVMName -Datastore $selected_datastore -VMHost $selected_host

#480Disconnect