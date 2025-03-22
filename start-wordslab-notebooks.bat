@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Usage : start-wordslab-notebooks.bat --name <wsl distribution name>(optional)
REM Default parameter values
set "name=wordslab-notebooks"

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
