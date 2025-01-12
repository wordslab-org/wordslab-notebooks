@echo off
setlocal

REM Usage : install-wordslab-notebooks.bat --cpu(optional) --name <wsl distribution name>(optional)
REM Default parameter values
set "name=wordslab-notebooks"
set "cpu=true"

REM Check if nvidia-smi exists and check if there is at least one GPU
where nvidia-smi >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%G in ('nvidia-smi --query-gpu=name --format=csv,noheader') do set "gpu_info=%%G"
    if defined gpu_info (
       set "cpu=false"
    )
) 

REM Parse command-line arguments
:parse_args
if "%~1"=="" goto end_args
if "%~1"=="--name" (
    set "name=%~2"
    shift
) else if "%~1"=="--models" (
    set "models=%~2"
    shift
) else if "%~1"=="--cpu" (
    set "cpu=true"
)
shift
goto parse_args
:end_args

REM Mandatory environment variables
REM WORDSLAB_WINDOWS_HOME: installation script and wordslab-notebooks virtual machine
REM WORDSLAB_WINDOWS_WORKSPACE: wordslab-notebooks-workspace virtual disk
REM WORDSLAB_WINDOWS_MODELS: wordslab-notebooks-workspace virtual disk

if not defined WORDSLAB_WINDOWS_HOME (
    set "WORDSLAB_WINDOWS_HOME=C:\wordslab"
)
if not defined WORDSLAB_WINDOWS_WORKSPACE (
    set "WORDSLAB_WINDOWS_WORKSPACE=%WORDSLAB_WINDOWS_HOME%\virtual-machines\wordslab-workspace"
)
if not defined WORDSLAB_WINDOWS_MODELS (
    set "WORDSLAB_WINDOWS_MODELS=%WORDSLAB_WINDOWS_HOME%\virtual-machines\wordslab-models" 
)

mkdir %WORDSLAB_WINDOWS_HOME%
cd %WORDSLAB_WINDOWS_HOME%

REM Download and unzip the installation scripts
curl -L -o wordslab-notebooks.zip https://github.com/wordslab-org/wordslab-notebooks/archive/refs/heads/main.zip
tar -x -f wordslab-notebooks.zip
del wordslab-notebooks.zip
ren wordslab-notebooks-main wordslab-notebooks

REM Execute Windows installation scripts

cd .\wordslab-notebooks\windows

call 1_install-or-update-windows-subsystem-for-linux.bat
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

call 2_create-linux-virtual-machine.bat %name%

REM Check if the shared virtual disks where already initialized
wsl -d wordslab-notebooks-workspace -- : >nul
if %errorlevel% nequ 0 (
    call 3_create-linux-virtual-disks.bat
)

call 4_mount-linux-virtual-disks.bat  %name%

call 5_install-linux-virtual-machine.bat %name% %cpu%

cd %WORDSLAB_WINDOWS_HOME%\wordslab-notebooks
