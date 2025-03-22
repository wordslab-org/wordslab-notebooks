#!/bin/bash

# Install the CPU version of Pytorch

pip install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 --index-url https://download.pytorch.org/whl/cpu

# Register that the install is CPU only
touch $WORDSLAB_NOTEBOOKS_ENV/.cpu-only
