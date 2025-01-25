REM Mandatory parameter : 2_create-linux-virtual-machine.bat <wsl distribution name>
REM Mandatory environment variables :
REM - %WORDSLAB_WINDOWS_HOME% : directory to store the wordslab-notebooks installation scripts and main virtual machine disk

mkdir %WORDSLAB_WINDOWS_HOME%\virtual-machines\%1
curl -L -o ubuntu-noble.tar https://partner-images.canonical.com/oci/noble/current/ubuntu-noble-oci-amd64-root.tar.gz
wsl --import %1 %WORDSLAB_WINDOWS_HOME%\virtual-machines\%1 ubuntu-noble.tar
del ubuntu-noble.tar

wsl -d %1 -- echo %WORDSLAB_WINDOWS_HOME% > /home/.WORDSLAB_WINDOWS_HOME
