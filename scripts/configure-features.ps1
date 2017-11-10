Write-Host "Activating required Windows features..."
Install-WindowsFeature -Name "Web-Server" -IncludeManagementTools
Install-WindowsFeature -Name "Web-Asp-Net45" -IncludeManagementTools
Install-WindowsFeature -Name "Web-AppInit" -IncludeManagementTools
Install-WindowsFeature -Name "Web-IP-Security" -IncludeManagementTools


