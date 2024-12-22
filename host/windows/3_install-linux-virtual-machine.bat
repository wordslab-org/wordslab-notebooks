REM Usage : 2_create-linux-virtual-machine.bat <wsl distribution name>(required) <cpu only?>(required)

rem Capture the current directory
set "originalDir=%cd%"

cd ..\..\server
wsl -d %1 -- ./0_install_on_windows_subsystem_for_linux.sh %2

rem Return to the original directory
cd "%originalDir%"
