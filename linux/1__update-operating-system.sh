#!/bin/bash
cpu_only=$1

# NB: you need to re-execute this script each time the container image is reset

# Install or update all the required Linux packages 
./1_1_install-ubuntu-packages.sh

# Install Docker only if we are not already inside a Docker container
if [ ! -f /.dockerenv ]; then
    ./1_2_install-docker.sh

    # Install the Nvidia container runtime 
    # in order to be able to access the GPU inside the Docker containers
    # only if a CPU-only setup was requested
    if [ ! "$cpu_only" == "true" ]; then
        ./1_2_install-nvidia-container-runtime.sh
    fi
fi

# Don't execute this right now when installing for the first time
# -> in this case, the shell is configured later at the end of the installation process
if [ -f /.wordslab-$WORDSLAB_VERSION-installed ]; then

    # When a new shell is launched
    # - define environment variables for storage paths and ports
    # - activate the right python environment 
    ./1_3_configure-shell-environment.sh
    
fi
