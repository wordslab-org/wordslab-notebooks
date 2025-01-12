#!/bin/bash
cpu_only=$1

# Install an independant and persistent python environment manager
# Create a conda environment for wordslab-notebooks
./2_1_install-python-environment.sh

# Activate this conda environment
source <("$CONDA_DIR/bin/conda" 'shell.bash' 'hook' 2> /dev/null)
conda activate $WORDSLAB_NOTEBOOKS_ENV

# Install the CPU or CUDA GPU version of Pytorch 
if [ "$cpu_only" == "true" ]; then
    ./2_2_install-pytorch-cpu.sh
else
    ./2_2_install-pytorch-cuda.sh
fi

# Install basic datascience librairies
# Configure all popular deeplearning librairies to download their models and datasets under the $WORDSLAB_MODELS directory (see _wordslab-notebooks-env.bashrc) 
./2_3_install-datascience-libs.sh

# Install Jupyterlab and a few usefuls extensions
# Configure Jupyterlab to store all its state under the $WORDSLAB_WORKSPACE directory (see _wordslab-notebooks-env.bashrc)
./2_4_install-jupyterlab.sh

# Setup scripts to create one virtual python environment and one ipython kernel per project
./2_5_setup-workspace-projects.sh

# Install Visual Studio Code server and Python extension
./2_6_install-vscode-server.sh

# Install Aider AI code assistant
./2_7_install-aider-ai-agent.sh
