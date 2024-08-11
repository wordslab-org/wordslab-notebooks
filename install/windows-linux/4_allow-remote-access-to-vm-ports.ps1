# Check if the script is running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Allowing remote access to wordslab-notebooks virtual machine requires Administrator privileges. Please open a new terminal as Administrator and restart the installation script."
    exit
}

# Get the IP address of the WSL virtual machine
$vmip = wsl -d wordslab-notebooks -- hostname -I
$vmip = $vmip.Trim()

# Default ports : Jupyterlab, Gradio, fastapi & fasthtml & VLLM, argilla.io
$defaultports = @(8888, 7860, 8000, 6900)

# Add default ports to the arguments list
$args += $defaultports

$firewallports = ""
for ( $i = 0; $i -lt $args.count; $i++ ) 
{
   $vmport = $args[$i]
   echo "- allow remote access to VM port $vmport"
   netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=$vmport connectaddress=$vmip connectport=$vmport
   if ( $firewallports.Length -gt 0 ) {
      $firewallports = $firewallports + ","
   }
   $firewallports = $firewallports + $vmport
}
if ( $firewallports.Length -gt 0 )
{
   echo "- configure firewall to allow inbound traffic on ports $firewallports"
   netsh advfirewall firewall add rule name="wordslab-notabooks" protocol=TCP dir=in localport=$firewallports action=allow
}

# Display remote URL
$ipaddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "169.254.*" -and $_.IPAddress -notlike "172.*" -and $_.IPAddress -notlike "127.*" })[0].IPAddress
Write-Output "You can now access your wordslab-notebooks environment from a remote machine at this URL: http://${ipaddress}:8888"
