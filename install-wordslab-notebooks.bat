@echo off
setlocal

REM Usage : install-wordslab-notebooks.bat --cpu(optional) --name <wsl distribution name>(optional) --models <windows path for models storage>(optional)
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

cd .\host\windows

call 1_install-or-update-windows-subsystem-for-linux.bat
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

call 2_create-linux-virtual-machine.bat %name%
call 3_install-linux-virtual-machine.bat %name% %cpu%

if defined models (
    call 4_create-linux-virtual-disk.bat "%models%"
) 

cd .\
