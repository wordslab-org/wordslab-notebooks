#!/bin/bash

# The installation directory, workspace directory, and models download directory can optionnaly be personalized as follows:
# WORDSLAB_HOME=/home WORDSLAB_WORKSPACE=/home/workspace WORDSLAB_MODELS=/home/models ./install-wordslab-notebooks.sh

# Set WORDSLAB_HOME to its default value if necessary

if [ -z "${WORDSLAB_HOME}" ]; then
    export WORDSLAB_HOME=/home
fi

# Navigate to the linux directory where all the scripts live
cd $WORDSLAB_HOME/wordslab-notebooks/linux

# Make sure the environment variables are initialized on Runpod
if [ -f /etc/rp_environment ] && [ -z "$RUNPOD_POD_ID" ]; then
    sed -i 's/^\(\[ -z "\$PS1" \] && return\)/# \1/' ~/.bashrc
    source ~/.bashrc
fi

# Set the initial environment variables
source ./_wordslab-notebooks-env.bashrc

# If the container root file system was reset after we restart an instance
# we need to reinstall the operating system packages and re configure the shell
if [ ! -f "/.wordslab-installed" ]; then
    ./1__update-operating-system.sh
fi

# Start all the wordslab-notebooks servers
./5_start-wordslab-notebooks.sh
