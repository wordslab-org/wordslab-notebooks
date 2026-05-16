#!/bin/bash

# Install the CUDA toolkit
#https://developer.nvidia.com/cuda-13-0-2-download-archive?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_network

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb
apt-get update
apt-get -y install cuda-toolkit-13-0

echo '' >> ./_wordslab-notebooks-env.bashrc
echo '# CUDA toolkit installation' >> ./_wordslab-notebooks-env.bashrc
echo 'export CUDA_HOME=/usr/local/cuda' >> ./_wordslab-notebooks-env.bashrc
echo 'export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH' >> ./_wordslab-notebooks-env.bashrc

# Create the vLLM environment

mkdir -p $VLLM_ENV
cp ./4_4_vllm-pyproject.toml $VLLM_ENV/pyproject.toml

# Download and install vLLM

cd $VLLM_ENV
if [ -f "$WORDSLAB_WORKSPACE/.cpu-only" ]; then
    uv sync --extra cpu
else
    uv sync --extra cuda
fi