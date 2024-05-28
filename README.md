
---

During my OSCP course times I've break system and took my time to recover.
After I search Google, I couldn't find any good tool that automates this process so here is a simple tool that will help you to not lose your VirtualBox states and save your time.

# Daily Snapshot Automation for VirtualBox

This PowerShell script automates the creation of daily backups for a VirtualBox VM, removing older snapshots to conserve space, and ensuring that only snapshots with the name format "DailyBackup_" are deleted if they are older than 2 days.

## Requirements
- Windows operating system
- VirtualBox installed
- PowerShell

## Usage
1. Download or clone the repository to your Windows Desktop.
2. Edit the `DailySnapshot.ps1` file:
   - Replace `$VMName` with your virtual machine's name.
   - Update `$VBoxManagePath` with the correct path to `VBoxManage.exe` if it's different on your system.
3. Run the script:
   ```powershell
   .\DailySnapshot.ps1
   ```

## If you want to schedule the script to run daily, follow these steps:
1. Open Task Scheduler.
2. Import the `DailySnap.xml` file included in the repository:
   - Right-click on "Task Scheduler Library" and select "Import Task..."
   - Browse to the location of the `DailySnap.xml` file and select it.
   - Click "Open" to import the task.
3. Edit the imported task:
   - Double-click on the imported task to open its properties.
   - Go to the "Actions" tab and edit the "Start a program" action to specify the correct path to PowerShell.exe and the `run.bat` script.
   - Click "OK" to save the changes.
---