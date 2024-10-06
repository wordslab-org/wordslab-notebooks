mkdir ..\..\wsl-vm
curl -L -o ubuntu-noble.tar https://partner-images.canonical.com/oci/noble/current/ubuntu-noble-oci-amd64-root.tar.gz
wsl --import wordslab-notebooks ..\..\wsl-vm ubuntu-noble.tar
del ubuntu-noble.tar

