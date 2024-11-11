$ErrorActionPreference = "Stop"

# Switch network connection to private mode
# Required for WinRM firewall rules
$profile = Get-NetConnectionProfile
Set-NetConnectionProfile -Name $profile.Name -NetworkCategory Private

# Install PS Windows Update Module
Get-PackageProvider -Name nuget -Force
Install-Module PSWindowsUpdate -Confirm:$false -Force

# Install Windows updates without user interaction and suppress reboot promptsequi
Get-WindowsUpdate -MicrosoftUpdate -Install -IgnoreUserInput -AcceptAll -IgnoreReboot | Out-File -FilePath 'C:\windowsupdate.log' -Append

# VMware Tools download and install section
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$downloadFolder = 'C:\install\'

# Ensure folder exists
if (-not (Test-Path -Path $downloadFolder)) {
    Write-Verbose "Creating folder '$downloadFolder'"
    New-Item -Path $downloadFolder -ItemType Directory -Force | Out-Null
}
else {
    Write-Verbose "Folder '$downloadFolder' already exists."
}

# Get the latest VMware Tools download link
$url = "https://packages.vmware.com/tools/releases/latest/windows/x64/"
$vmwareLink = Invoke-WebRequest -Uri $url -UseBasicParsing | ForEach-Object {
    $_.Links | Where-Object { $_.href -match '^VM.*' } | Select-Object -ExpandProperty href -First 1
}

if ($vmwareLink) {
    $downloadUrl = "$url$vmwareLink"
    $downloadPath = Join-Path -Path $downloadFolder -ChildPath (Split-Path -Path $vmwareLink -Leaf)

    # Download the file
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath -UseBasicParsing
        Write-Host "Downloaded VMware Tools to '$downloadPath'"
    }
    catch {
        Write-Error "Failed to download VMware Tools: $_"
        exit 1
    }

    # Install VMware Tools without reboot
    try {
        Start-Process -FilePath $downloadPath -ArgumentList '/S /v"/qn REBOOT=ReallySuppress" /l c:\windows\temp\vmware_tools_install.log' -Wait
        Write-Host "VMware Tools installation completed."
    }
    catch {
        Write-Error "Failed to install VMware Tools: $_"
        exit 1
    }
}
else {
    Write-Error "No VMware Tools download link found."
    exit 1
}

# WinRM Configuration
winrm quickconfig -quiet
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

# Reset auto logon count
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0

# Trigger a single reboot at the end
Restart-Computer -Force
