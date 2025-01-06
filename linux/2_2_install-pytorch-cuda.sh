#!/bin/bash

# Create a dedicated conda environment to install the CUDA GPU version of Pytorch
# The files are stored in an independent and persistent directory: $WORDSLAB_NOTEBOOKS_ENV (see _wordslab-notebooks-env.bashrc)

source <("$CONDA_DIR/bin/conda" 'shell.bash' 'hook' 2> /dev/null)

conda create -y --prefix $WORDSLAB_NOTEBOOKS_ENV python==3.12.8 ninja=1.12.1 ipykernel=6.29.5
conda activate $WORDSLAB_NOTEBOOKS_ENV

pip install torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1
