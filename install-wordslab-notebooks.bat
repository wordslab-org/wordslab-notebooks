@echo off
cd .\install\windows-linux
call 1_install-or-update-windows-subsystem-for-linux.bat
call 2_create-linux-virtual-machine.bat
call 3_install-linux-virtual-machine.bat
