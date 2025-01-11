REM Mandatory parameters : 3_create_linux_models_disk.bat <windows directory for shared models disk>

mkdir %~1\wordslab-notebooks-models
curl -L -o alpine.tar https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/x86_64/alpine-minirootfs-3.21.0-x86_64.tar.gz
wsl --import wordslab-notebooks-models %~1\wordslab-notebooks-models alpine.tar
del alpine.tar

wsl -d wordslab-notebooks-models -- mkdir -p /home/models



