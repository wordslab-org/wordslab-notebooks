#!/bin/bash

# Install Aider - AI pair programming in your terminal
UV_TOOL_DIR=$WORDSLAB_NOTEBOOKS_ENV/uv/tools UV_TOOL_BIN_DIR=$WORDSLAB_NOTEBOOKS_ENV/bin uv tool install --force --python python3.12 aider-chat==0.80.3
