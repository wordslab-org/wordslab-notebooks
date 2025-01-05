#!/bin/bash

# Install uv package manager, which is required to install aider
pip install uv  

# Install Aider latest version
uv tool install --force --python python3.12 aider-chat@latest