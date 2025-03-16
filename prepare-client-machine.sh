#!/bin/bash

secretsDir="./secrets"

# Create secrets directory if it doesn't exist
if [ ! -d "$secretsDir" ]; then
    mkdir -p "$secretsDir"
fi

tarFile="$secretsDir/wordslab-client-secrets.tar"

# Extract tar file if it exists
if [ -f "$tarFile" ]; then
    echo "Reusing client secrets from another client machine in wordslab-client-secrets.tar"
    tar -xf "$tarFile" -C "$secretsDir"
fi

ssh_key="$secretsDir/ssh-key"

# Generate SSH key if it doesn't exist
if [ ! -f "$ssh_key" ]; then
    echo "Generating SSH key"
    ssh-keygen -t ed25519 -f "$ssh_key" -N ""
fi

# Set secrets directory for mkcert
export CAROOT="$secretsDir"

# Download mkcert if it doesn't exist
if [ ! -f "./linux/mkcert" ]; then
    echo "Downloading mkcert"
    curl -sSL https://dl.filippo.io/mkcert/latest?for=linux/amd64 -o ./linux/mkcert

    if [ -f "mkcert" ]; then
        echo "Installing mkcert local certificate authority"
        ./linux/mkcert -install
    else
        echo "Failed to download mkcert"
        exit 1
    fi
fi

# Create tar archive for client secrets
tar -cf "$secretsDir/wordslab-client-secrets.tar" "$secretsDir/ssh-key" "$secretsDir/ssh-key.pub" "$secretsDir/rootCA.pem" "$secretsDir/rootCA-key.pem"
if [ $? -ne 0 ]; then
    echo "Failed to create tar archive for client"
    exit $?
else
    echo "Secrets for client machine stored in $CAROOT/wordslab-client-secrets.tar"
fi

echo "Client machine is ready"

if [ ! -f "$tarFile" ]; then
    echo ""
    echo "If you plan to use other client machines to access the same remote servers, you need to transfer the client secrets to the other machines."
    echo ""
    echo "[Windows client machine]"
    echo "1. Create a secrets directory for wordslab on the other client machine"
    echo "   > set \"WORDSLAB_WINDOWS_HOME=C:\\wordslab\" && call mkdir \"%WORDSLAB_WINDOWS_HOME%\\secrets\""
    echo "2. Transfer the file $CAROOT/wordslab-client-secrets.tar to the %WORDSLAB_WINDOWS_HOME%\\secrets directory on the remote machine"
    echo "   (USB stick, email, shared directory ...)"
    echo "3. Execute the script prepare-client-machine.bat on the remote machine"
    echo "   > set \"WORDSLAB_WINDOWS_HOME=C:\\wordslab\" && curl -sSL https://raw.githubusercontent.com/wordslab-org/wordslab-notebooks/refs/heads/main/prepare-client-machine.bat -o \"%temp%\\prepare-client-machine.bat\" && call \"%temp%\\prepare-client-machine.bat\""
    echo ""
    echo "[Linux client machine]"
    echo "1. Create a secrets directory for wordslab on the other client machine"
    echo "   > WORDSLAB_SCRIPTS=/home/wordslab-notebooks && mkdir -p \$WORDSLAB_SCRIPTS/secrets"
    echo "2. Transfer the file $CAROOT/wordslab-client-secrets.tar to the \$WORDSLAB_SCRIPTS/secrets directory on the remote machine"
    echo "   (USB stick, email, shared directory, scp ...)"
    echo "3. Execute the script prepare-client-machine.sh on the remote machine"
    echo "   > export WORDSLAB_SCRIPTS=/home/wordslab-notebooks && curl -sSL https://raw.githubusercontent.com/wordslab-org/wordslab-notebooks/refs/heads/main/prepare-client-machine.sh -o \$WORDSLAB_SCRIPTS/prepare-client-machine.sh && \$WORDSLAB_SCRIPTS/prepare-client-machine.sh"
fi
