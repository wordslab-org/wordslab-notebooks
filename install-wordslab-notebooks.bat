@echo off
setlocal

REM Usage 1 - Install on local Widows machine
REM install-wordslab-notebooks.bat --cpu(optional) --name <wsl distribution name>(optional)
REM Default parameter values
set "name=wordslab-notebooks"
set "cpu=true"

REM Route to local windows mode
if "%~1"=="" goto windows_mode
if "%~1"=="--" goto windows_mode
if "%~2"=="--" goto windows_mode

REM Usage 2 - Install on remote Linux machine
REM install-wordslab-notebooks.bat <server address> <server ssh port>(optional)

REM Mandatory environment variables
REM WORDSLAB_VERSION: wordslab-notebook version TAG in github repo
if not defined WORDSLAB_VERSION (
    set "WORDSLAB_VERSION=2025-10"
)

REM Default parameter values
set "port=22"

REM Parse command-line arguments
set address=%~1
if not "%~2"=="" set port=%~2

REM Normalize secrets directory
set secretsDir=%~dp0\..\secrets
pushd %secretsDir%
set secretsDir=%CD%
popd

REM Check if the SSH key exists
if not exist "%secretsDir%\ssh-key" (
    echo Please execute prepare-client-machine.bat first and register the public SSH key with the cloud provider.
    exit /b 1
)

REM First detect the remote platform
for /f "delims=" %%i in ('ssh -p %port% -o "StrictHostKeyChecking=no" root@%address% -i "%secretsDir%\ssh-key" "[ -f /etc/environment ] && source /etc/environment; [ -f /etc/rp_environment ] && source /etc/rp_environment; grep -qi microsoft /proc/version && echo WindowsSubsystemForLinux || ([ -n \"$MACHINE_ID\" ] && [ -n \"$MACHINE_NAME\" ] && echo Jarvislabs.ai) || ([ -n \"$RUNPOD_POD_ID\" ] && echo Runpod.io) || ([ -n \"$VAST_TCP_PORT_22\" ] && echo Vast.ai) || echo UnknownLinux"') do set "WORDSLAB_PLATFORM=%%i"
echo The remote platform is: %WORDSLAB_PLATFORM%

REM Set WORDSLAB_HOME based on WORDSLAB_PLATFORM
if "%WORDSLAB_PLATFORM%"=="Jarvislabs.ai" (
    set "WORDSLAB_HOME=/home/jl_fs"
) else if "%WORDSLAB_PLATFORM%"=="Runpod.io" (
    set "WORDSLAB_HOME=/workspace"
) else if "%WORDSLAB_PLATFORM%"=="Vast.ai" (
    set "WORDSLAB_HOME=/workspace"
) else (
    set "WORDSLAB_HOME=/home"
)

REM On Jarvislabs, we need to copy the API key to get the dahsboard URL
if "%WORDSLAB_PLATFORM%"=="Jarvislabs.ai" (
    if not exist "%secretsDir%\jarvislabs-api-key" (
        echo To install on Jarvislabs, please first go to https://jarvislabs.ai/settings/api-keys, generate an API key, then save this key in a file named %secretsDir%\jarvislabs-api-key
        exit /b 1
    )
    ssh -p %port% -o StrictHostKeyChecking=no root@%address% -i "%secretsDir%\ssh-key" "mkdir -p %WORDSLAB_HOME%/workspace/.secrets"
    scp -P %port% -i %secretsDir%\ssh-key %secretsDir%\jarvislabs-api-key root@%address%:%WORDSLAB_HOME%/workspace/.secrets/jarvislabs-api-key
)

REM Execute the install script through a secure SSH connection to the remote Linux server
if "%WORDSLAB_VERSION%"=="main" (
    ssh -p %port% -o StrictHostKeyChecking=no root@%address% -i "%secretsDir%\ssh-key" "apt update && apt install -y curl && export WORDSLAB_HOME=%WORDSLAB_HOME% && export WORDSLAB_WORKSPACE=\$WORDSLAB_HOME/workspace && export WORDSLAB_MODELS=\$WORDSLAB_HOME/models && export WORDSLAB_VERSION=%WORDSLAB_VERSION% && curl -sSL https://raw.githubusercontent.com/wordslab-org/wordslab-notebooks/refs/heads/main/install-wordslab-notebooks.sh | bash"
) else (
    ssh -p %port% -o StrictHostKeyChecking=no root@%address% -i "%secretsDir%\ssh-key" "apt update && apt install -y curl && export WORDSLAB_HOME=%WORDSLAB_HOME% && export WORDSLAB_WORKSPACE=\$WORDSLAB_HOME/workspace && export WORDSLAB_MODELS=\$WORDSLAB_HOME/models && export WORDSLAB_VERSION=%WORDSLAB_VERSION% && curl -sSL https://raw.githubusercontent.com/wordslab-org/wordslab-notebooks/refs/tags/%WORDSLAB_VERSION%/install-wordslab-notebooks.sh | bash"
)

exit /b 0

REM Install on local Windows machine
:windows_mode

REM Mandatory environment variables
REM WORDSLAB_WINDOWS_HOME: installation script and wordslab-notebooks virtual machine
if not defined WORDSLAB_WINDOWS_HOME (
    set "WORDSLAB_WINDOWS_HOME=C:\wordslab"
)
REM WORDSLAB_WINDOWS_WORKSPACE: wordslab-notebooks-workspace virtual disk
if not defined WORDSLAB_WINDOWS_WORKSPACE (
    set "WORDSLAB_WINDOWS_WORKSPACE=%WORDSLAB_WINDOWS_HOME%\virtual-machines\wordslab-workspace"
)
REM WORDSLAB_WINDOWS_MODELS: wordslab-notebooks-workspace virtual disk
if not defined WORDSLAB_WINDOWS_MODELS (
    set "WORDSLAB_WINDOWS_MODELS=%WORDSLAB_WINDOWS_HOME%\virtual-machines\wordslab-models" 
)
REM WORDSLAB_VERSION: wordslab-notebook version TAG in github repo (or main to get the main branch)
if not defined WORDSLAB_VERSION (
    set WORDSLAB_VERSION=2025-10
)

if not exist "%WORDSLAB_WINDOWS_HOME%" mkdir %WORDSLAB_WINDOWS_HOME%
cd %WORDSLAB_WINDOWS_HOME%

REM Download and unzip the installation scripts
if "%WORDSLAB_VERSION%"=="main" (
    curl -L -o wordslab-notebooks.zip https://github.com/wordslab-org/wordslab-notebooks/archive/refs/heads/main.zip
) else (
    curl -L -o wordslab-notebooks.zip https://github.com/wordslab-org/wordslab-notebooks/archive/refs/tags/%WORDSLAB_VERSION%.zip
)
tar -x -f wordslab-notebooks.zip
del wordslab-notebooks.zip

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
) else if "%~1"=="--cpu" (
    set "cpu=true"
)
shift
goto parse_args
:end_args

REM Set up default startup script with the right path
(
    echo set "WORDSLAB_WINDOWS_HOME=%WORDSLAB_WINDOWS_HOME%"
    echo set "WORDSLAB_VERSION=%WORDSLAB_VERSION%"
    echo call cd "%%WORDSLAB_WINDOWS_HOME%%\wordslab-notebooks-%%WORDSLAB_VERSION%%"
    echo call start-wordslab-notebooks.bat %%1 %%2
) > start-wordslab-notebooks.bat

REM Execute Windows installation scripts

cd .\wordslab-notebooks-%WORDSLAB_VERSION%\windows

call 1_install-or-update-windows-subsystem-for-linux.bat
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

REM This will only create the virtual machine if it doesn't exist
call 2_create-linux-virtual-machine.bat %name%

REM This will only create the virtual disks if they don't exist
call 3_create-linux-virtual-disks.bat

call 4_mount-linux-virtual-disks.bat  %name%

call 5_install-linux-virtual-machine.bat %name% %cpu%

cd %WORDSLAB_WINDOWS_HOME%
