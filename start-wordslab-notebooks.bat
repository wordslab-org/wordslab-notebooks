@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Usage 1 - Start on local Widows machine
REM start-wordslab-notebooks.bat --name <wsl distribution name>(optional)
REM Default parameter values
set "name=wordslab-notebooks"

REM Route to local windows mode
if "%~1"=="" goto windows_mode
if "%~1"=="--" goto windows_mode

REM Usage 2 - Start on remote Linux machine
REM start-wordslab-notebooks.bat <server address> <server ssh port>(optional)
REM Default parameter values
set "port=22"

REM Start on remote Linux machine

REM Parse command-line arguments
set address=%~1
if not "%~2"=="" set port=%~2

REM First detect the remote platform
for /f "delims=" %%i in ('ssh -p %port% -o StrictHostKeyChecking=no root@%address% -i "%ssh_key%" "grep -qi microsoft /proc/version && echo WindowsSubsystemForLinux || ([ -n \"$MACHINE_ID\" ] && [ -n \"$MACHINE_NAME\" ] && echo Jarvislabs.ai) || ([ -n \"$RUNPOD_POD_ID\" ] && echo Runpod.io) || ([ -n \"$VAST_TCP_PORT_22\" ] && echo Vast.ai) || echo UnknownLinux"') do set "WORDSLAB_PLATFORM=%%i"
echo The remote platform is: %WORDSLAB_PLATFORM%

REM Set CERTIFICATE_ADDRESS based on WORDSLAB_PLATFORM
if "%WORDSLAB_PLATFORM%"=="Jarvislabs.ai" (
    set "CERTIFICATE_ADDRESS=*.notebooks.jarvislabs.net"
) else if "%WORDSLAB_PLATFORM%"=="Runpod.io" (
    set "CERTIFICATE_ADDRESS=*.proxy.runpod.net"
) else (
    set "CERTIFICATE_ADDRESS=%address%"
)
REM For filenames, replace '*' with 'any'
set "FILENAME_ADDRESS=!CERTIFICATE_ADDRESS:*=any!"

# REM Prepare secrets if they don't already exist

prepare-server-secrets.bat "%CERTIFICATE_ADDRESS%"
scp -P %port% -i C:\wordslab\secrets\ssh-key C:\wordslab\secrets\wordslab-server-%FILENAME_ADDRESS%-secrets.tar root@%address%:/workspace/workspace/.secrets/wordslab-server-secrets.tar

# REM Send secrets to the server 
cd $WORDSLAB_WORKSPACE/.secrets
tar -xvf wordslab-server-secrets.tar

REM Start on local Windows machine
:windows_mode

REM Parse command-line arguments
if "%~1"=="" goto end_args
if "%~1"=="--name" (
    set "name=%~2"
)
:end_args

cd .\windows

call 4_mount-linux-virtual-disks.bat

REM Check if a SSL certificate is installed
REM => launch wordslab-notebooks in "remote access" mode
REM => allow remote access to ports 8880-8888 of the WSL virtual machine
REM Note: we need to do this each time we start the VM, because its IP address changes each time you launch WSL
wsl -d wordslab-notebooks-workspace -- sh -c "if [ -f /home/workspace/.secrets/certificate.pem ]; then exit 0; else exit 1; fi"
if !ERRORLEVEL! equ 0 (
    echo Launching wordslab-notebooks in "remote access" mode
    echo - opening and forwarding ports 8880-8888 to the virtual machine
    net session >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        PowerShell -ExecutionPolicy Bypass -File 6_allow-remote-access-to-vm-ports.ps1 %*
    ) else (
        echo - requesting administrator privileges to launch the script 6_allow-remote-access-to-vm-ports.ps1
        PowerShell -Command "Start-Process PowerShell -ArgumentList '-ExecutionPolicy Bypass -File %CD%\6_allow-remote-access-to-vm-ports.ps1 %*' -Verb RunAs"
    )
)

cd ..

wsl -d %name% -- bash -i /home/wordslab-notebooks/start-wordslab-notebooks.sh
