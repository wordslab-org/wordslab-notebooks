@echo off

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
if %errorlevel% equ 0 (
    echo Launching wordslab-notebooks in "remote access" mode: opening and forwarding ports 8880-8888 to the virtual machine
    net session >nul 2>&1
    if %errorLevel% GTR 0 (
        echo Requesting administrator privileges...
        PowerShell -Command "Start-Process '%~f0' -Verb RunAs"
        exit /B
    )
    PowerShell -ExecutionPolicy Bypass -File 6_allow-remote-access-to-vm-ports.ps1 %*
)

cd ..

wsl -d %name% -- bash -i /home/wordslab-notebooks/start-wordslab-notebooks.sh
