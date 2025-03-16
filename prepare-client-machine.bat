@echo off
set "secretsDir=..\secrets"

if not exist %secretsDir% (
    mkdir %secretsDir%
)

if not exists prepare-client-machine.bat (
   curl -sSL https://raw.githubusercontent.com/wordslab-org/wordslab-notebooks/refs/heads/main/prepare-client-machine.bat
)

set "tarFile=%secretsDir%\wordslab-client-secrets.tar"
if exist "%tarFile%" (
    echo Reusing client secrets from another client machine in wordslab-client-secrets.tar
    tar -xf "%tarFile%" -C "%extractDir%"
)

set ssh_key=%secretsDir%\ssh-key
if not exist %ssh_key% (
    echo Generating SSH key
    ssh-keygen -t ed25519 -f %ssh_key% -N ""
)

REM Set secrets directory for mkcert
pushd %~dp0%secretsDir%
set CAROOT=%CD%
popd

if not exist windows\mkcert.exe (
    echo Downloading mkcert
    curl -sSL https://dl.filippo.io/mkcert/latest?for=windows/amd64 -o windows\mkcert.exe

    if exist windows\mkcert.exe (
        echo Installing mkcert local certificate authority
        windows\mkcert.exe -install
    ) else (
        echo Failed to download mkcert
        exit /b 1
    )
)

tar -cf %secretsDir%\wordslab-client-secrets.tar %secretsDir%\ssh-key.pem %secretsDir%\ssh-key-pub.pem %secretsDir%\rootCA.pem %secretsDir%\rootCA-key.pem
if %errorlevel% neq 0 (
    echo Failed to create tar archive for client
    exit /b %errorlevel%
) else (
    echo Secrets for client machine stored in %CAROOT%client.tar
)

echo Client machine is ready

if not exist "%tarFile%" (

echo
echo If you plan to use other client machines to access the same remote servers, you need to transfer the client secrets to the other machines.
echo 
echo [Windows client machine]
echo 1. Create a secrets directory for wordslab on the other client machine
echo    > set "WORDSLAB_WINDOWS_HOME=C:\wordslab" && call mkdir "%WORDSLAB_WINDOWS_HOME%\secrets"
echo 2. Transfer the file %CAROOT%wordslab-client-secrets.tar to the %%WORDSLAB_WINDOWS_HOME%%\secrets directory on the remote machine
echo    (USB stick, email, shared directory ...)
echo 3. Execute the script prepare-client-machine.bat on the remote machine
echo    > set "WORDSLAB_WINDOWS_HOME=C:\wordslab" && curl -sSL https://raw.githubusercontent.com/wordslab-org/wordslab-notebooks/refs/heads/main/prepare-client-machine.bat -o "%temp%\prepare-client-machine.bat" && call "%temp%\prepare-client-machine.bat"
echo  
echo [Linux client machine] 
echo 1. Create a secrets directory for wordslab on the other client machine
echo    > WORDSLAB_SCRIPTS=/home/wordslab-notebooks && mkdir -p $WORDSLAB_SCRIPTS/secrets
echo 2. Transfer the file %CAROOT%wordslab-client-secrets.tar to the $WORDSLAB_SCRIPTS/secrets directory on the remote machine
echo    (USB stick, email, shared directory, scp ...)
echo 3. Execute the script prepare-client-machine.sh on the remote machine
echo    > export WORDSLAB_SCRIPTS=/home/wordslab-notebooks && curl -sSL https://raw.githubusercontent.com/wordslab-org/wordslab-notebooks/refs/heads/main/prepare-client-machine.sh -o $WORDSLAB_SCRIPTS/prepare-client-machine.sh && $WORDSLAB_SCRIPTS/prepare-client-machine.sh

)
