$ErrorActionPreference = "Stop"

# Create a folder for installation logs
$logFolder = 'C:\install_logs'
if (-not (Test-Path -Path $logFolder)) {
    Write-Host "Creating log folder at $logFolder..."
    New-Item -Path $logFolder -ItemType Directory -Force | Out-Null
}

# Mount VirtIO ISO and install drivers silently
$virtioDrive = "E:"  # Assuming the VirtIO ISO is mounted as drive E:
$virtioInstaller = Join-Path -Path $virtioDrive -ChildPath "virtio-win-gt-x64.msi"
$qemuInstaller = Join-Path -Path $virtioDrive -ChildPath "guest-agent\qemu-ga-x86_64.msi"

# Install VirtIO drivers
if (Test-Path $virtioInstaller) {
    Write-Host "Running VirtIO driver installation from $virtioInstaller..."
    try {
        # Execute the silent installation
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$virtioInstaller`" /qn ADDLOCAL=ALL /norestart" -Wait -NoNewWindow
        Write-Host "VirtIO driver installation completed successfully."
    }
    catch {
        Write-Error "Failed to run VirtIO driver installation: $_"
        exit 1
    }
}
else {
    Write-Error "VirtIO installer not found at $virtioInstaller. Exiting..."
    exit 1
}

# Install QEMU Guest Agent
if (Test-Path $qemuInstaller) {
    Write-Host "Installing QEMU Guest Agent from $qemuInstaller..."
    try {
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$qemuInstaller`" /qn" -Wait -NoNewWindow
        Start-Service -Name qemu-ga
        Set-Service -Name qemu-ga -StartupType Automatic
        Write-Host "QEMU Guest Agent installed and configured successfully."
    }
    catch {
        Write-Error "Failed to install QEMU Guest Agent: $_"
        exit 1
    }
}
else {
    Write-Error "QEMU Guest Agent installer not found at $qemuInstaller. Skipping installation."
}

# Install PS Windows Update Module
Write-Host "Installing PSWindowsUpdate module..."
Get-PackageProvider -Name nuget -Force | Out-Null
Install-Module PSWindowsUpdate -Confirm:$false -Force

# Install Windows updates without user interaction and suppress reboot prompts
Write-Host "Running Windows Update..."
Get-WindowsUpdate -MicrosoftUpdate -Install -IgnoreUserInput -AcceptAll -IgnoreReboot | Out-File -FilePath "$logFolder\windowsupdate.log" -Append

# Switch network connection to private mode
$profile = Get-NetConnectionProfile
Set-NetConnectionProfile -Name $profile.Name -NetworkCategory Private

# WinRM Configuration
Write-Host "Configuring WinRM..."
winrm quickconfig -quiet
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

# Reset auto logon count
Write-Host "Resetting auto logon count..."
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0

# Trigger a single reboot at the end
Write-Host "Rebooting the system..."
Restart-Computer -Force
