#!/bin/bash

# NB: this script can only be run after 2__install_wordslab-notebooks.sh AND 3__install-open-webui.sh

if [ ! -f ~/.wordslab-installed ]; then

    # Source _wordslab-notebooks.bashrc in ~/.bashrc
    # - set environment variables for storage and ports
    # - start a new shell in the right Python environment and the right directory
    
    echo '' >> ~/.bashrc
    echo source $WORDSLAB_SCRIPTS/linux/_wordslab-notebooks-env.bashrc >> ~/.bashrc
    echo source $WORDSLAB_SCRIPTS/linux/_wordslab-notebooks-init.bashrc >> ~/.bashrc
    
    # Add a flag file to avoid updating ~/.bashrc twice
    touch ~/.wordslab-installed
fi