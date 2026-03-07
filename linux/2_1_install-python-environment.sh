#!/bin/bash

# Donwload and install uv, the modern Python package manager
mkdir -p $UV_INSTALL_DIR
curl -LsSf https://astral.sh/uv/0.10.9/install.sh | sh
source $UV_INSTALL_DIR/env

# Install Python version
uv python install 3.12.13
