@echo off

if not exist ..\secrets (
    mkdir ..\secrets
)


REM Generate an SSH key if it doesn't exist
set ssh_key=..\secrets\id_ed25519
if not exist %ssh_key% (
    echo Generating SSH key
    ssh-keygen -t ed25519 -f %ssh_key% -N ""
)

if not exist windows\mkcert.exe (
    echo Downloading mkcert
    powershell -Command "Invoke-WebRequest -Uri 'https://dl.filippo.io/mkcert/latest?for=windows/amd64' -OutFile 'windows\mkcert.exe'"
    if exist windows\mkcert.exe (
        echo Installing mkcert
        windows\mkcert.exe -install
    ) else (
        echo Failed to download mkcert
        exit /b 1
    )
)

REM Ask the user to enter an IP address or machine name
set /p machine=Please enter the IP address or machine name for wordslab-notebooks:

windows\mkcert.exe -cert-file ..\secrets\%machine%.pem -key-file ..\secrets\%machine%-key.pem %machine% localhost 127.0.0.1 ::1
echo Certificates generated for %machine%

REM Ask the user to enter a password and store it in the file %machine%.password
set /p password=Please enter a password for accessing this machine:

echo %password% > ..\secrets\%machine%.password
echo Password stored in ../secrets/%machine%.password
