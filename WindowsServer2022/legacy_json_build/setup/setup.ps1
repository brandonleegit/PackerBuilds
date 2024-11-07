$ErrorActionPreference = "Stop"

# Switch network connection to private mode
# Required for WinRM firewall rules
$profile = Get-NetConnectionProfile
Set-NetConnectionProfile -Name $profile.Name -NetworkCategory Private

#Install PS Windows Update Module

Get-PackageProvider -name nuget -force
Install-Module PSWindowsUpdate -confirm:$false -force
Get-WindowsUpdate -MicrosoftUpdate -install -IgnoreUserInput -acceptall -AutoReboot | Out-File -filepath 'c:\windowsupdate.log' -append

#WinRM Configure
winrm quickconfig -quiet
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

# Reset auto logon count
# https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-autologon-logoncount#logoncount-known-issue
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0