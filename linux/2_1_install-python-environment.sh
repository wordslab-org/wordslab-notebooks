#!/bin/bash

# Donwload and install uv, the modern Python package manager
mkdir -p $UV_INSTALL_DIR
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc

# Install Python version
uv python install 3.12.10