#!/bin/bash

# Install the CUDA GPU version of Pytorch

pip install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0

# Install vllm here because it will now be closely linked to a version of Pytorch

pip install vllm==0.8.3
