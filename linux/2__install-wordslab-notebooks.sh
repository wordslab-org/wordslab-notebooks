#!/bin/bash
cpu_only=$1

# Install an independant and persistent python environment manager
./2_1_install-python-envmanager.sh

# Create a, inedependent and persistent conda environment with the CPU or CUDA GPU version of Pytorch 
if [ "$cpu_only" == "true" ]; then
    ./2_2_install-pytorch-cpu.sh
else
    ./2_2_install-pytorch-cuda.sh
fi

# Activate this conda environment
source <("$CONDA_DIR/bin/conda" 'shell.bash' 'hook' 2> /dev/null)
conda activate $WORDSLAB_NOTEBOOKS_ENV

# Install basic datascience librairies
# Configure all popular deeplearning librairies to download their models and datasets under the $WORDSLAB_MODELS directory (see _wordslab-notebooks-env.bashrc) 
./2_3_install_datascience_libs.sh

# Install Jupyterlab and a few usefuls extensions
# Configure Jupyterlab to store all its state under the $WORDSLAB_WORKSPACE directory (see _wordslab-notebooks-env.bashrc)
./2_4_install-jupyterlab.sh

# Setup scripts to create one virtual python environment and one ipython kernel per project
./2_5_setup-virtual-environments-scripts.sh

# Install Visual Studio Code server and Python extension
./2_6_install-vscode-server.sh

# Install Aider AI code assistant
./2_7_install-aider-ai-agent.sh
