@echo off

set secretsDir=%~dp0\..\secrets
if not exist %secretsDir% (
    mkdir %secretsDir%
)

REM Normalize secrets directory
pushd %secretsDir%
set secretsDir=%CD%
popd

if not exist prepare-server-secrets.bat (
   curl -sSL https://raw.githubusercontent.com/wordslab-org/wordslab-notebooks/refs/heads/main/prepare-server-secrets.bat -o %~dp0\prepare-server-secrets.bat
)

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

if not exist %~dp0\mkcert.exe (
    echo Downloading mkcert
    curl -sSL https://dl.filippo.io/mkcert/latest?for=windows/amd64 -o %~dp0\mkcert.exe

    if exist %~dp0\mkcert.exe (
        REM Set secrets directory for mkcert
        set CAROOT=%secretsDir%
        echo Installing mkcert local certificate authority
        %~dp0\mkcert.exe -install
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

cd %~dp0
