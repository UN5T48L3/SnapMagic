# Configuration
$VMName = "centos7" # Replace with your VM name
$VBoxManagePath = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

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

# Delete snapshots older than 3 days
$cutOffDate = (Get-Date).AddDays(-2)
foreach ($snapshot in $snapshots) {
    $snapshotDate = [DateTime]::ParseExact($snapshot.Split('_')[1], "dd-MM-yyyy-HH-mm", $null)
    if ($snapshotDate -lt $cutOffDate) {
        Write-Output "Deleting old snapshot: $snapshot"
        Delete-Snapshot -VMName $VMName -SnapshotName $snapshot
    }
}

# Create a new snapshot
$timestamp = (Get-Date).ToString("dd-MM-yyyy-HH-mm")
$SnapshotName = "DailyBackup_$timestamp"
Write-Output "Creating new snapshot: $SnapshotName"
Create-Snapshot -VMName $VMName -SnapshotName $SnapshotName

Write-Output "Snapshot operation completed."
