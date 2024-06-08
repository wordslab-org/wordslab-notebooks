mkdir ..\..\wsl-vm
curl -L -o ubuntu-noble.tar https://partner-images.canonical.com/oci/noble/current/ubuntu-noble-oci-amd64-root.tar.gz
wsl --import wordslab-notebooks ..\..\wsl-vm ubuntu-noble.tar
del ubuntu-noble.tar
wsl -d wordslab-notebooks -- ./3_install-linux-virtual-machine.sh

cd ..\linux
wsl -d wordslab-notebooks -- ./1_install-python-environment-manager.sh
wsl -d wordslab-notebooks -- ./2_install-cuda-pytorch.sh

