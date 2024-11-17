@echo off
net session >nul 2>&1
if %errorLevel% GTR 0 (
    echo Requesting administrator privileges...
    PowerShell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /B
)

PowerShell -ExecutionPolicy Bypass -File %~dp0host\windows\5_allow-remote-access-to-vm-ports.ps1 %*

pause
