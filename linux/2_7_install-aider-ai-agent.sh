#!/bin/bash

# Install uv package manager, which is required to install aider
pip install uv  

# Install Aider specific version
UV_TOOL_DIR=$WORDSLAB_NOTEBOOKS_ENV/uv/tools UV_TOOL_BIN_DIR=$WORDSLAB_NOTEBOOKS_ENV/bin uv tool install --force --python python3.12 aider-chat==0.70.0
