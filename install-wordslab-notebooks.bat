@echo off
cd .\install\windows

call 1_install-or-update-windows-subsystem-for-linux.bat
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

call 2_create-linux-virtual-machine.bat
call 3_install-linux-virtual-machine.bat

cd .\
