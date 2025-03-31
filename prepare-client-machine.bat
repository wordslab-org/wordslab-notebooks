@echo off

REM This script can be called in two contexts
REM - on a machine where the scripts are already installed: the sibling file prepare-server-secrets.bat already exists
REM - or directly from a github URL, on a machine where nothing is installed yet: in this case we need to download the scripts first

if not exist prepare-server-secrets.bat (

    REM Mandatory environment variable
    REM WORDSLAB_WINDOWS_HOME: installation scripts and client/server secrets
    if not defined WORDSLAB_WINDOWS_HOME (
        set "WORDSLAB_WINDOWS_HOME=C:\wordslab-client"
    )

    mkdir "%WORDSLAB_WINDOWS_HOME%"
    cd /d "%WORDSLAB_WINDOWS_HOME%"

    REM Download and unzip the installation scripts
    curl -L -o wordslab-notebooks.zip https://github.com/wordslab-org/wordslab-notebooks/archive/refs/heads/main.zip
    tar -x -f wordslab-notebooks.zip
    del wordslab-notebooks.zip
    ren wordslab-notebooks-main wordslab-notebooks

    set "scriptsDir=%WORDSLAB_WINDOWS_HOME%\wordslab-notebooks"
    cd /d "%scriptsDir%"

) else (

    set "scriptsDir=%~dp0"

)

set "secretsDir=%scriptsDir%\..\secrets"
if not exist "%secretsDir%" (
    mkdir "%secretsDir%"
)

REM Normalize secrets directory
pushd "%secretsDir%"
set "secretsDir=%CD%"
popd

set "tarFile=%secretsDir%\wordslab-client-secrets.tar"
if not exist "%secretsDir%\rootCA.pem" (
    if exist "%tarFile%" (
        echo Reusing client secrets from another client machine in wordslab-client-secrets.tar
        tar -xf "%tarFile%" -C "%secretsDir%"
    )
)

set "ssh_key=%secretsDir%\ssh-key"
if not exist "%ssh_key%" (
    echo Generating SSH key
    ssh-keygen -t ed25519 -f "%ssh_key%" -N "" -q
)

if not exist "%scriptsDir%\mkcert.exe" (
    echo Downloading mkcert
    curl -sSL https://dl.filippo.io/mkcert/latest?for=windows/amd64 -o "%scriptsDir%\mkcert.exe"

    if exist "%scriptsDir%\mkcert.exe" (
        REM Set secrets directory for mkcert
        set "CAROOT=%secretsDir%"
        echo Installing mkcert local certificate authority
        "%scriptsDir%\mkcert.exe" -install
    ) else (
        echo Failed to download mkcert
        exit /b 1
    )
)

if not exist "%tarFile%" (
    tar -cf "%tarFile%" -C "%secretsDir%" ssh-key ssh-key.pub rootCA.pem rootCA-key.pem
    if %errorlevel% neq 0 (
        echo Failed to create tar archive for client
        exit /b %errorlevel%
    )
)

echo Client machine is ready: secrets stored in %tarFile%
echo.
echo To install wordslab-notebooks on a cloud server machine, you can now execute the following steps:
echo.
echo 1. Register your public SSH key with a cloud provider
echo --- COPY THE LINE BELOW ---
type "%ssh_key%.pub"
echo --- COPY THE LINE ABOVE ---
echo.
echo 2. Select, configure and start a cloud machine, then display the SSH command to access the machine
echo.
echo 3. Execute the following script to install wordlsab-notebooks on the cloud machine
echo ^> install-wordslab-notebooks.bat [linux server SSH address] [linux server SSH port](optional: default=22)
echo.
echo To generate secrets for a local server machine, execute the following command:
echo ^> prepare-server-secrets.bat
echo.
echo Note: if you plan to use other client machines, you need to transfer %tarFile% to these machines. Please refer to the documentation at https://github.com/wordslab-org/wordslab-notebooks/.
echo.

cd /d "%scriptsDir%"
