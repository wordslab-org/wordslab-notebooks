#!/bin/bash

# NB: this script can only be run after 2__install_wordslab-notebooks.sh AND 3__install-open-webui.sh

# Source _wordslab-notebooks.bashrc in ~/.bashrc
# - set environment variables for storage and ports
# - start a new shell in the right Python environment and the right directory

# Note that these commands will accumulate in ~/.bashrc as you install successive versions
# => the last version overwrites the previous values
echo '' >> ~/.bashrc
echo source $WORDSLAB_SCRIPTS/linux/_wordslab-notebooks-env.bashrc >> ~/.bashrc
echo source $WORDSLAB_SCRIPTS/linux/_wordslab-notebooks-init.bashrc >> ~/.bashrc

# Add a flag file to ditinguish the first install from the following updates
echo $WORDSLAB_VERSION > ~/.wordslab-installed
