#!/bin/bash

# Install the latest release of Miniforge : minimal installers for Conda and Mamba specific to conda-forge
# The files are stored in an independent and persistent directory: $CONDA_DIR (see _wordslab-notebooks-env.bashrc)

curl -L -O "https://github.com/conda-forge/miniforge/releases/download/25.3.0-1/Miniforge3-Linux-x86_64.sh"

bash Miniforge3-Linux-x86_64.sh -b -p $CONDA_DIR

rm  Miniforge3-Linux-x86_64.sh

# Create a dedicated conda environment to install wordslab-notebooks
# The files are stored in an independent and persistent directory: $WORDSLAB_NOTEBOOKS_ENV (see _wordslab-notebooks-env.bashrc)

source <("$CONDA_DIR/bin/conda" 'shell.bash' 'hook' 2> /dev/null)

conda create -y --prefix $WORDSLAB_NOTEBOOKS_ENV python==3.12.10 ninja=1.12.1 ipykernel=6.29.5
conda activate $WORDSLAB_NOTEBOOKS_ENV

# Update pip package installer
pip install --upgrade pip

# Install uv package manager, which is growing in popularity and is required to install Aider
pip install uv  

# Install Jarvislabs.ai client library if necessary
if [ "$WORDSLAB_PLATFORM" = "Jarvislabs.ai" ]; then
   pip install git+https://github.com/jarvislabsai/jlclient.git
fi

# Install wordslab notebooks dashboard

cd $WORDSLAB_SCRIPTS/dashboard
./install-dashboard.sh
