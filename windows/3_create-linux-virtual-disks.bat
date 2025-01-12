REM No parameters : 3_create_linux_virtual_disks.bat
REM Mandatory environment variables :
REM - %WORDSLAB_WINDOWS_WORKSPACE% : directory to store the virtual disk for the wordslab workspace
REM - %WORDSLAB_WINDOWS_MODELS% : directory to store the virtual disk for the wordslab models

mkdir %~1\wordslab-notebooks-models
curl -L -o alpine.tar https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/x86_64/alpine-minirootfs-3.21.0-x86_64.tar.gz
wsl --import wordslab-notebooks-workspace %WORDSLAB_WINDOWS_WORKSPACE% alpine.tar
wsl --import wordslab-notebooks-models %WORDSLAB_WINDOWS_MODELS% alpine.tar
del alpine.tar

wsl -d wordslab-notebooks-workspace -- mkdir -p /home/workspace
wsl -d wordslab-notebooks-models -- mkdir -p /home/models


