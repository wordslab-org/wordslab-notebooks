@echo off

REM Usage : start-wordslab-notebooks.bat --name <wsl distribution name>(optional)
REM Default parameter values
set "name=wordslab-notebooks"

REM Parse command-line arguments
if "%~1"=="" goto end_args
if "%~1"=="--name" (
    set "name=%~2"
)
:end_args

cd .\windows

call 4_mount-linux-virtual-disks.bat

cd ..

wsl -d %name% -- bash -i /home/wordslab-notebooks/start-wordslab-notebooks.sh
