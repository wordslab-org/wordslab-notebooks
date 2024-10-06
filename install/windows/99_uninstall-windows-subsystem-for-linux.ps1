wsl --shutdown
wsl --uninstall
Remove-Item "$env:USERPROFILE\.wslconfig"

Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName VirtualMachinePlatform
