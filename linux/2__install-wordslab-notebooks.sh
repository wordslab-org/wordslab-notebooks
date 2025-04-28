#!/bin/bash
cpu_only=$1

# Install an independant and persistent python environment manager
# Create a conda environment for wordslab-notebooks
./2_1_install-python-environment.sh

# Add uv in the PATH after installing it
source $UV_INSTALL_DIR/env

# Install wordslab-notebooks dashboard
./2_2_install-dashboard.sh

# Install Jupyterlab and a few usefuls extensions
# Configure Jupyterlab to store all its state under the $WORDSLAB_WORKSPACE directory (see _wordslab-notebooks-env.bashrc)
./2_3_install-jupyterlab.sh

# Setup scripts to create one virtual python environment and one ipython kernel per project
./2_4_setup-workspace-projects.sh

# Install basic datascience librairies
# Install Pytorch
# Install VLLM (GPU only)
# Configure all popular deeplearning librairies to download their models and datasets under the $WORDSLAB_MODELS directory (see _wordslab-notebooks-env.bashrc) 
./2_5_install-datascience-libs.sh $cpu_only
