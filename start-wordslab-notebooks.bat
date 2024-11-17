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

REM Check if a separate disk was initialized to store the models
wsl -l -q | findstr /i "^wordslab-notebooks-models$" >nul
if %errorlevel% equ 0 (
    wsl -d wordslab-notebooks-models -- mkdir -p /mnt/wsl/wordslab-notebooks-models
    wsl -d wordslab-notebooks-models -- mount --bind /data /mnt/wsl/wordslab-notebooks-models
    wsl -d %name% -- mount --bind /mnt/wsl/wordslab-notebooks-models /models
)

wsl -d %name% -- bash -i ~/start-wordslab-notebooks.sh
