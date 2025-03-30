@echo off
setlocal

REM Usage 1 - Install on local Widows machine
REM install-wordslab-notebooks.bat --cpu(optional) --name <wsl distribution name>(optional)
REM Default parameter values
set "name=wordslab-notebooks"
set "cpu=true"

REM Usage 2 - Install on remote Linux machine
REM install-wordslab-notebooks.bat <server address> <server ssh port>(optional)
REM Default parameter values
set "port=22"

REM Mandatory environment variables
REM WORDSLAB_WINDOWS_HOME: installation script and wordslab-notebooks virtual machine
if not defined WORDSLAB_WINDOWS_HOME (
    set "WORDSLAB_WINDOWS_HOME=C:\wordslab"
)

mkdir %WORDSLAB_WINDOWS_HOME%
cd %WORDSLAB_WINDOWS_HOME%

REM Download and unzip the installation scripts
curl -L -o wordslab-notebooks.zip https://github.com/wordslab-org/wordslab-notebooks/archive/refs/heads/main.zip
tar -x -f wordslab-notebooks.zip
del wordslab-notebooks.zip
ren wordslab-notebooks-main wordslab-notebooks

REM Route to local windows mode
if "%~1"=="" goto windows_mode
if "%~1"=="--" goto windows_mode
if "%~2"=="--" goto windows_mode

REM Install on remote Linux machine

REM Parse command-line arguments
set address=%~1
if not "%~2"=="" set port=%~2

REM Check if the SSH key exists
if not exist "%WORDSLAB_WINDOWS_HOME%\secrets\ssh-key" (
    echo Please execute prepare-client-machine.bat first and register the public SSH key with the cloud provider.
    exit /b 1
)

REM Execute the following commands through a secure SSH connection to the remote Linux server
ssh -p %port% -o StrictHostKeyChecking=no root@%address% -i "%WORDSLAB_WINDOWS_HOME%\secrets\ssh-key" << EOF
    apt update && apt install -y curl
    export WORDSLAB_HOME=/workspace
    export WORDSLAB_WORKSPACE=\$WORDSLAB_HOME/workspace
    export WORDSLAB_MODELS=\$WORDSLAB_HOME/models
    curl -sSL https://raw.githubusercontent.com/wordslab-org/wordslab-notebooks/refs/heads/main/install-wordslab-notebooks.sh | bash
    echo The public address of the server is \$PUBLIC_IPADDR
EOF

exit /b 0

REM Install on local Windows machine
:windows_mode

REM Mandatory environment variables
REM WORDSLAB_WINDOWS_WORKSPACE: wordslab-notebooks-workspace virtual disk
if not defined WORDSLAB_WINDOWS_WORKSPACE (
    set "WORDSLAB_WINDOWS_WORKSPACE=%WORDSLAB_WINDOWS_HOME%\virtual-machines\wordslab-workspace"
)
REM WORDSLAB_WINDOWS_MODELS: wordslab-notebooks-workspace virtual disk
if not defined WORDSLAB_WINDOWS_MODELS (
    set "WORDSLAB_WINDOWS_MODELS=%WORDSLAB_WINDOWS_HOME%\virtual-machines\wordslab-models" 
)

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
    echo call cd "%%WORDSLAB_WINDOWS_HOME%%\wordslab-notebooks"
    echo call start-wordslab-notebooks.bat
) > start-wordslab-notebooks.bat

REM Execute Windows installation scripts

cd .\wordslab-notebooks\windows

call 1_install-or-update-windows-subsystem-for-linux.bat
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

call 2_create-linux-virtual-machine.bat %name%

REM Check if the shared virtual disks where already initialized
wsl -d wordslab-notebooks-workspace -- : >nul
if %errorlevel% neq 0 (
    call 3_create-linux-virtual-disks.bat
)

call 4_mount-linux-virtual-disks.bat  %name%

call 5_install-linux-virtual-machine.bat %name% %cpu%

cd %WORDSLAB_WINDOWS_HOME%\wordslab-notebooks
