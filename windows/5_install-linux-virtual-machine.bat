REM Usage : 5_install-linux-virtual-machine <wsl distribution name>(required) <cpu only?>(required)

rem Capture the current directory
set "originalDir=%cd%"

REM Note : you can't change WORDSLAB_WORKSPACE or WORDSLAB_MODELS default paths in the WSL virtual machine
REM => this would break 4_mount-linux-virtual-disks.bat

cd ..
wsl -d %1 -- ./install-wordslab-notebooks.sh %2

rem Return to the original directory
cd "%originalDir%"
