REM Mandatory parameter : 2_create-linux-virtual-machine.bat <wsl distribution name>

mkdir ..\..\wsl-vm
curl -L -o ubuntu-noble.tar https://partner-images.canonical.com/oci/noble/current/ubuntu-noble-oci-amd64-root.tar.gz
wsl --import %1 ..\..\wsl-vm ubuntu-noble.tar
del ubuntu-noble.tar

