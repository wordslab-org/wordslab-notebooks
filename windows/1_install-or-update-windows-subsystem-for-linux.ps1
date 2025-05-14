# As a prerequisite, you should :
# 1. Update Windows to the latest version
# > start ms-settings:windowsupdate
# 2. Update yoour Nividia GPU driver to the latest version
# > "C:\Program Files\NVIDIA Corporation\NVIDIA GeForce Experience\NVIDIA GeForce Experience.exe"

# Run wsl --status and capture the output
$statusOutput = wsl --status 2>&1
$returnCode = $LASTEXITCODE

# Check if the output is empty
if ([string]::IsNullOrWhiteSpace($statusOutput) -or $returnCode -ne 0) {
    # The output is empty, so run wsl --install --no-distribution
    Write-Output "Windows Subsystem for Linux is not installed. Installing WSL without a default distribution..."   
    wsl --install --no-distribution

    # By default WSL only uses half of the host memory: configure it to use up to the host memory minus 2 GB
    $wslConfigPath = "$env:USERPROFILE\.wslconfig"
    $totalMemoryGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
    $wslMemoryGB = $totalMemoryGB - 2
    $content = @"
[wsl2]
memory=${wslMemoryGB}GB
"@
    Set-Content -Path $wslConfigPath -Value $content

    Write-Host ""
    Write-Host "IMPORTANT:"
    Write-Host "Please note that you will need to reboot your machine and re-execute this script to finish the installation."

    # Ask the user if they want to reboot the machine
    $rebootChoice = Read-Host "Do you want to reboot the machine now? (Y/N)"
    if ($rebootChoice -eq 'Y' -or $rebootChoice -eq 'y') {
        Write-Host "Rebooting the machine..."
        Restart-Computer
    } else {
        exit 1
    }

} else {
    # The output is not empty, so run wsl --update
    Write-Output "Windows Subsystem for Linux is installed. Updating WSL to the latest version..."
    wsl --update
}
