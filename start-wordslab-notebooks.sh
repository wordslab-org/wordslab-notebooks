#!/bin/bash

# The installation directory, workspace directory, and models download directory can optionnaly be personalized as follows:
# WORDSLAB_HOME=/home WORDSLAB_WORKSPACE=/home/workspace WORDSLAB_MODELS=/home/models ./install-wordslab-notebooks.sh

# Set WORDSLAB_HOME to its default value if necessary

if [ -z "${WORDSLAB_HOME}" ]; then
    export $WORDSLAB_HOME=/home
fi

# If the container root file system was reset after we restart an instance
# we need to reinstall the operating system packages and re configure the shell
if [ ! -f "/.wordslab-$WORDSLAB_VERSION-installed" ]; then
    # Navigate to the linux directory where all the scripts live
    cd $WORDSLAB_HOME/wordslab-notebooks/linux

    # Set the initial environment variables
    source ./_wordslab-notebooks-env.bashrc

    # Install or update all the required Linux packages 
    ./1__update-operating-system.sh
fi

# Initialize the Python environment 
# (this will also change directory to $WORDSLAB_WORKSPACE)
source ~/.bashrc

# Navigate (again) to the linux directory where all the scripts live
cd $WORDSLAB_HOME/wordslab-notebooks/linux

# Start all the wordslab-notebooks servers
./4_start-wordslab-notebooks.sh
