#!/bin/bash

# Install the CPU version of Pytorch

pip install torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1 --index-url https://download.pytorch.org/whl/cpu

# Register that the install is CPU only
touch $WORDSLAB_NOTEBOOKS_ENV/.cpu-only
