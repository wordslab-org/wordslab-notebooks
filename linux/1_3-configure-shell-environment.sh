#!/bin/bash

# NB: this script can only be run after 2__install_wordslab-notebooks.sh AND 3__install-open-webui.sh

# Source _wordslab-notebooks.bashrc in ~/.bashrc
# - set environment variables for storage and ports
# - start a new shell in the right Python environment and the right directory

cp ./_wordslab-notebooks-env.bashrc ~
cp ./_wordslab-notebooks-init.bashrc ~
cp ./4_start-wordslab-notebooks-and-open-webui.sh ~/start-wordslab-notebooks.sh

echo '' >> ~/.bashrc
echo 'source ~/_wordslab-notebooks-env.bashrc' >> ~/.bashrc
echo 'source ~/_wordslab-notebooks-init.bashrc' >> ~/.bashrc

# Add a flag file to avoid installing twice
touch /.wordslab-$WORDSLAB_VERSION-installed
