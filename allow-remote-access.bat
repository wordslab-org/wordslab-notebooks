@echo off
net session >nul 2>&1
if %errorLevel% != 0 (
    echo Requesting administrator privileges...
    PowerShell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /B
)

cd install\windows
4_allow-remote-access-to-vm-ports.bat %*
