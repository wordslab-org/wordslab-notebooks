@echo off

REM Normalize secrets directory
set secretsDir=%~dp0\..\secrets
pushd %secretsDir%
set secretsDir=%CD%
popd

if not exist %~dp0\mkcert.exe (
    echo The client machine needs to be prepared first: please execute prepare-client-machine.bat
    exit /b 1
)
if not exist %secretsDir%\rootCA-key.pem (
    echo The client machine needs to be prepared first: please execute prepare-client-machine.bat
    exit /b 1
)

REM Set secrets directory for mkcert
set CAROOT=%secretsDir%

REM Check if the machine parameter is passed to the script, or get the input from the user
if "%~1"=="" (
    set /p machine=Please enter the IP address or DNS name of the remote machine on which you want to install wordslab-notebooks:
) else (
    set machine=%~1
)

REM Generate the SSL certificate for the server machine
%~dp0\mkcert.exe -cert-file %secretsDir%\certificate.pem -key-file %secretsDir%\certificate-key.pem %machine% localhost 127.0.0.1 ::1

set password=
set /p "password=Please enter a password for accessing this remote machine (or leave empty for no password):" 
if "%password%"=="" (
    type nul > %secretsDir%\password
    echo %machine% will be accessible without password
) else (
    echo %password% > %secretsDir%\password
)

tar -cf %secretsDir%\wordslab-server-%machine%-secrets.tar -C %secretsDir% certificate.pem certificate-key.pem password
if %errorlevel% neq 0 (
    echo Failed to create tar archive for %machine%
    exit /b %errorlevel%
)
del %secretsDir%\certificate.pem
del %secretsDir%\certificate-key.pem
del %secretsDir%\password

echo. 
echo The secrets for the remote wordslab-notebooks server are stored in %secretsDir%\wordslab-server-%machine%-secrets.tar
echo.

if "%~1"=="" (
    echo Now you need to transfer these secrets to the server machine: please refer to the documentation at https://github.com/wordslab-org/wordslab-notebooks/.
    echo.
)
