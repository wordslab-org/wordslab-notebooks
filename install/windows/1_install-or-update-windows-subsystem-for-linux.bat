@echo off
PowerShell -ExecutionPolicy Bypass -File .\1_install-or-update-windows-subsystem-for-linux.ps1
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%
