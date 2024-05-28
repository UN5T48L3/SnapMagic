Tabii ki, işte ingilizce bir README dosyası örneği:

---

# Daily Snapshot Automation for VirtualBox

This script automates the process of creating a daily snapshot for a VirtualBox virtual machine and deleting any existing snapshots to save disk space. It is designed to be used with Windows operating systems.

## Requirements
- Windows operating system
- VirtualBox installed
- PowerShell

## Usage
1. Download or clone the repository to your local machine.
2. Edit the `DailySnapshot.ps1` file:
   - Replace `$VMName` with your virtual machine's name.
   - Update `$VBoxManagePath` with the correct path to `VBoxManage.exe` if it's different on your system.
3. Run the script:
   ```powershell
   .\DailySnapshot.ps1
   ```
4. If you want to schedule the script to run daily, follow these steps:
   - Open Task Scheduler.
   - Import the `DailySnap.xml` file included in the repository:
     - Right-click on "Task Scheduler Library" and select "Import Task..."
     - Browse to the location of the `DailySnap.xml` file and select it.
     - Click "Open" to import the task.
   - Edit the imported task:
     - Double-click on the imported task to open its properties.
     - Go to the "Actions" tab and edit the "Start a program" action to specify the correct path to PowerShell.exe and the `DailySnapshot.ps1` script.
   - Click "OK" to save the changes.
---