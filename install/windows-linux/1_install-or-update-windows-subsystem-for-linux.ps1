# Run wsl --status and capture the output
$statusOutput = wsl --status 2>&1

# Check if the output is empty
if ([string]::IsNullOrWhiteSpace($statusOutput)) {
    # The output is empty, so run wsl --install --no-distribution
    Write-Output "Windows Subsystem for Linux is not installed. Installing WSL without a default distribution..."

    # Check if the script is running as Administrator
    if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Error "This installation requires Administrator privileges. Please run it as Administrator."
        exit
    }
    
    wsl --install --no-distribution
} else {
    # The output is not empty, so run wsl --update
    Write-Output "Windows Subsystem for Linux is installed. Updating WSL to the latest version..."
    wsl --update
}