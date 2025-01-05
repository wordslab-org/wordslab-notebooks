#!/bin/bash

# Install the latest release of Miniforge : minimal installers for Conda and Mamba specific to conda-forge
# The files are stored in an independent and persistent directory: $CONDA_DIR (see _wordslab-notebooks-env.bashrc)

curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"

mkdir -p $CONDA_DIR

bash Miniforge3-Linux-x86_64.sh -b -p $CONDA_DIR

rm  Miniforge3-Linux-x86_64.sh