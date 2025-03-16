#!/bin/bash

if [ ! -f "./linux/mkcert" ]; then
    echo "The client machine needs to be prepared first: please execute prepare-client-machine.sh"
    exit 1
fi

# Set secrets directory for mkcert
export CAROOT=$WORSDLAB_SCRIPTS/secrets

read -p "Please enter the IP address or DNS name of the remote machine on which you want to install wordslab-notebooks: " machine
./linux/mkcert -cert-file ../secrets/certificate.pem -key-file ../secrets/certificate-key.pem "$machine" localhost 127.0.0.1 ::1
echo "SSL certificates generated for $machine"

read -p "Please enter a password for accessing this remote machine (or leave empty for no password): " password
echo "$password" > ../secrets/password
if [ -z "$password" ]; then
    echo "$machine will be accessible without password"
else
    echo "Password stored for $machine"
fi

tar -cf ../secrets/wordslab-server-"$machine"-secrets.tar ../secrets/certificate.pem ../secrets/certificate-key.pem ../secrets/password
if [ $? -ne 0 ]; then
    echo "Failed to create tar archive for $machine"
    exit $?
else
    echo "Secrets for remote machine stored in $CAROOT/wordslab-server-$machine-secrets.tar"
fi
rm ../secrets/certificate.pem ../secrets/certificate-key.pem ../secrets/password

echo
echo "First: make sure that wordslab-notebooks is already installed on the remote machine."
echo
echo "[Windows remote machine]"
echo "1. Transfer the file $CAROOT/wordslab-server-$machine-secrets.tar to the %WORDSLAB_WINDOWS_HOME%\secrets directory on the remote machine"
echo "   (USB stick, email, shared directory)"
echo "2. Execute the following commands on the remote Windows machine:"
echo "   > echo %WORDSLAB_WINDOWS_HOME%"
echo "   > wsl -d wordslab-notebooks"
echo "   > cp \"\$(wslpath -u '[insert %WORDSLAB_WINDOWS_HOME% value here]\secrets\wordslab-server-$machine-secrets.tar')\" \$WORDSLAB_WORKSPACE/.secrets"
echo "   > tar -xvf \$WORDSLAB_WORKSPACE/.secrets/wordslab-server-$machine-secrets.tar -C \$WORDSLAB_WORKSPACE/.secrets/"
echo
echo "[Linux remote machine]"
echo "1. Transfer the file $CAROOT/wordslab-server-$machine-secrets.tar to the \$WORDSLAB_WORKSPACE/.secrets directory on the remote machine"
echo "   > scp -i \$WORDSLAB_WINDOWS_HOME/secrets/ssh-key \"$CAROOT/wordslab-server-$machine-secrets.tar\" username@remote_host:\$WORDSLAB_WORKSPACE/.secrets/"
echo "2. Uncompress wordslab-server-$machine-secrets.tar in the \$WORDSLAB_WORKSPACE/.secrets directory of the remote machine"
echo "   > ssh -i \$WORDSLAB_WINDOWS_HOME/secrets/ssh-key username@remote_host \"tar -xvf \$WORDSLAB_WORKSPACE/.secrets/wordslab-server-$machine-secrets.tar -C \$WORDSLAB_WORKSPACE/.secrets/\""
echo
echo "3. Restart wordslab-notebooks on the remote machine: it will now be exposed with the https secure protocol and password protection"
