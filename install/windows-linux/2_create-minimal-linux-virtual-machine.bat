mkdir ..\..\wsl-vm
curl -L -o ubuntu-jammy.tar https://partner-images.canonical.com/oci/jammy/current/ubuntu-jammy-oci-amd64-root.tar.gz 
wsl --import wordslab-notebooks ..\..\wsl-vm ubuntu-jammy.tar
del ubuntu-jammy.tar
wsl -d wordslab-notebooks -- apt update && apt install --yes wget
wsl -d wordslab-notebooks -- wget xxx && chmod u+x xx && ./xxx && rm xxx
