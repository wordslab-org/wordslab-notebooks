@echo off

REM This script can be called in two contexts
REM - on a machine where the scripts are already installed: the sibling file prepare-server-secrets.bat already exists
REM - or directly from a github URL, on a machine where nothing is installed yet: in this case we need to download the scripts first

if not exist prepare-server-secrets.bat  (

    REM Mandatory environment variable    
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

    set scriptsDir=%WORDSLAB_WINDOWS_HOME%\wordslab-notebooks
    cd %scriptsDir%

) else (

    set scriptsDir=%~dp0

)

set secretsDir=%scriptsDir%\..\secrets
if not exist %secretsDir% (
    mkdir %secretsDir%
)

REM Normalize secrets directory
pushd %secretsDir%
set secretsDir=%CD%
popd

set "tarFile=%secretsDir%\wordslab-client-secrets.tar"
if not exist "%secretsDir%\rootCA.pem" (
    if exist "%tarFile%" (
        echo Reusing client secrets from another client machine in wordslab-client-secrets.tar
        tar -xf "%tarFile%" -C "%secretsDir%"
    )
)

set ssh_key=%secretsDir%\ssh-key
if not exist %ssh_key% (
    echo Generating SSH key
    ssh-keygen -t ed25519 -f %ssh_key% -N "" -q
)

if not exist %scriptsDir%\mkcert.exe (
    echo Downloading mkcert
    curl -sSL https://dl.filippo.io/mkcert/latest?for=windows/amd64 -o %scriptsDir%\mkcert.exe

    if exist%scriptsDir%\mkcert.exe (
        REM Set secrets directory for mkcert
        set CAROOT=%secretsDir%
        echo Installing mkcert local certificate authority
        %scriptsDir%\mkcert.exe -install
    ) else (
        echo Failed to download mkcert
        exit /b 1
    )
)

if not exist %tarFile% (
    tar -cf %tarFile% -C %secretsDir% ssh-key ssh-key.pub rootCA.pem rootCA-key.pem
    if %errorlevel% neq 0 (
        echo Failed to create tar archive for client
        exit /b %errorlevel%
    )
)

echo Client machine is ready: secrets stored in %tarFile%
echo.
echo If you plan to use other client machines to access the same remote wordslab-notebooks servers, you need to transfer the client secrets to the other machines: please refer to the documentation at https://github.com/wordslab-org/wordslab-notebooks/.
echo.
echo To generate secrets for a server machine, you can now execute the following command:
echo ^> prepare-server-secrets.bat
echo.

cd %scriptsDir%
