# Check if the script is running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Allowing remote access to wordslab-notebooks virtual machine requires Administrator privileges. Please open a new terminal as Administrator and restart the installation script."
    exit
}

# Default ports : Jupyterlab, Gradio, fastapi & VLLM, argilla
if ($args.count -eq 0) {
    $args = @(8888, 7860, 8000, 6900)
}

$firewallports = ""
for ( $i = 0; $i -lt $args.count; $i++ ) 
{
   $vmport = $args[$i]
   echo "- allow remote access to VM port $vmport"
   netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=$vmport connectaddress=127.0.0.1 connectport=$vmport
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
