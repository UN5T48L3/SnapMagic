# Configuration
$VMName = "centos7" # Replace with your VM name
$VBoxManagePath = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

# Generate snapshot name with timestamp
$timestamp = (Get-Date).ToString("dd-MM-yyyy-HH-mm")
$SnapshotName = "DailyBackup_$timestamp"

# Function to create a snapshot
function Create-Snapshot {
    param (
        [string]$VMName,
        [string]$SnapshotName
    )
    Start-Process -FilePath $VBoxManagePath -ArgumentList "snapshot $VMName take $SnapshotName --description `"Daily Backup taken on $timestamp`"" -NoNewWindow -Wait
}

# Function to delete a snapshot
function Delete-Snapshot {
    param (
        [string]$VMName,
        [string]$SnapshotName
    )

    $existingSnapshot = & $VBoxManagePath snapshot $VMName list --machinereadable | Select-String -Pattern "SnapshotName=`"$SnapshotName`"" -Quiet

    if ($existingSnapshot) {
        Start-Process -FilePath $VBoxManagePath -ArgumentList "snapshot $VMName delete $SnapshotName" -NoNewWindow -Wait
    } else {
        Write-Output "Snapshot $SnapshotName not found. Skipping deletion."
    }
}


# Get list of existing snapshots
$snapshots = & $VBoxManagePath snapshot $VMName list --machinereadable | Select-String -Pattern 'SnapshotName="DailyBackup_' | ForEach-Object { $_.ToString().Split('=')[1].Trim('"') }

# Check if there are any existing snapshots
if ($snapshots.Count -gt 0) {
    # Delete existing snapshots
    foreach ($snapshot in $snapshots) {
        Write-Output "Deleting old snapshot: $snapshot"
        Delete-Snapshot -VMName $VMName -SnapshotName $snapshot
    }
} else {
    Write-Output "No old snapshots found. Skipping deletion."
}

# Create a new snapshot
Write-Output "Creating new snapshot: $SnapshotName"
Create-Snapshot -VMName $VMName -SnapshotName $SnapshotName

Write-Output "Snapshot operation completed."
