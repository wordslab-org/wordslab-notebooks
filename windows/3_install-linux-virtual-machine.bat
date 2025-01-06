REM Usage : 2_create-linux-virtual-machine.bat <wsl distribution name>(required) <cpu only?>(required)

rem Capture the current directory
set "originalDir=%cd%"

cd ..
wsl -d %1 -- ./install-wordslab-notebooks.sh %2

rem Return to the original directory
cd "%originalDir%"
