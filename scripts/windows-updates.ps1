$ProgressPreference='SilentlyContinue'

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module PSWindowsUpdate -SkipPublisherCheck -Force


Install-WindowsUpdate -WindowsUpdate -AcceptAll -UpdateType Software -IgnoreReboot

