@echo off

REM Get the IP address of the Windows server machine (first non WSL and non loopback IP address)
for /f %%I in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-NetIPAddress -AddressFamily IPv4 -AddressState Preferred | Where-Object {($_.InterfaceAlias -notmatch 'WSL') -and ($_.InterfaceAlias -notmatch 'Loopback')} | Select-Object -ExpandProperty IPAddress"') do set IP=%%I

REM Write the IP address to a file in the WSL /home directory
wsl -d wordslab-notebooks -- bash -c "echo %IP% > /home/.WORDSLAB_WINDOWS_IP"

set "tarfile="
for %%f in ("..\secrets\wordslab-server-%IP%-secrets.tar") do (
    set "tarfile=%%~nxf"
)

if defined tarfile (
    echo Installing secrets files on the server machine:
    wsl -d wordslab-notebooks-workspace -- sh -c "mkdir -p /home/workspace/.secrets && cp ../secrets/%tarfile% /home/workspace/.secrets && cd /home/workspace/.secrets && tar -xvf %tarfile%"
) else (
    echo You first need to copy the wordslab-server-%IP%-secrets.tar file of the secrets generated on the client machine to the ..\secrets directory.
)
