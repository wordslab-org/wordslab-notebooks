#!/bin/bash

# Navigate to the linux directory where all the scripts live
cd linux

# Set the initial environment variables
source ./_wordslab-notebooks-env.bashrc

# If the container root file system was reset after we restart an instance
# we need to reinstall the operating system packages and re configure the shell
if [ ! -f "/.wordslab-$WORDSLAB_VERSION-installed" ]; then
    # Install or update all the required Linux packages 
    ./1__update-operating-system.sh
fi

# Make sure all the necessary Ubtunu packages are installed
./4_start-wordslab-notebooks.sh
