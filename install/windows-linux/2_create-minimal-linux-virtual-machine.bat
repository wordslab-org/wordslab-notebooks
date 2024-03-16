mkdir ..\..\wsl-vm
curl -L -o ubuntu-jammy.tar https://partner-images.canonical.com/oci/jammy/current/ubuntu-jammy-oci-amd64-root.tar.gz 
wsl --import wordslab-notebooks ..\..\wsl-vm ubuntu-jammy.tar
del ubuntu-jammy.tar
wsl -d wordslab-notebooks -- ./3_install-linux-virtual-machine.sh
