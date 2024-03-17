mkdir ..\..\wsl-vm
curl -L -o ubuntu-jammy.tar https://partner-images.canonical.com/oci/jammy/current/ubuntu-jammy-oci-amd64-root.tar.gz 
wsl --import wordslab-notebooks ..\..\wsl-vm ubuntu-jammy.tar
del ubuntu-jammy.tar
wsl -d wordslab-notebooks -- ./3_install-linux-virtual-machine.sh

cd ..\linux
wsl -d wordslab-notebooks -- ./1_install-python-environment-manager.sh
wsl -d wordslab-notebooks -- ./2_install-cuda-pytorch-2.2.sh

