REM Usage : 5_install-linux-virtual-machine <wsl distribution name>(required) <cpu only?>(required)

rem Capture the current directory
set "originalDir=%cd%"

cd ..
wsl -d %1 -- ./install-wordslab-notebooks.sh %2

rem Return to the original directory
cd "%originalDir%"
