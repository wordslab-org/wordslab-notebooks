@echo off
echo %~f0
net session >nul 2>&1
if %errorLevel% GTR 0 (
    echo Requesting administrator privileges...
    PowerShell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /B
)

PowerShell -ExecutionPolicy Bypass -File %~dp0install\windows\4_allow-remote-access-to-vm-ports.ps1 %*

pause
