#!/bin/bash

# NB: this script can only be run after 2__install_wordslab-notebooks.sh AND 3__install-open-webui.sh

# Insert conda initialization code in ~/.bashrc
eval "$('$CONDA_DIR/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
conda init bash

# Source _wordslab-notebooks.bashrc in ~/.bashrc
# - set environment variables for storage and ports
# - start a new shell in the right Python environment and the right directory
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
echo 'source $SCRIPT_DIR/_wordslab-notebooks-env.bashrc' >> ~/.bashrc
echo 'source $SCRIPT_DIR/_wordslab-notebooks-init.bashrc' >> ~/.bashrc

# Add a flag file to avoid installing twice
touch /.wordslab-$WORDSLAB_VERSION-installed