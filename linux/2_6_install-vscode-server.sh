#!/bin/bash

# Install Visual Studio Code server in a persistent directory (see _wordslab-notebooks-env.bashrc)
curl -fsSL https://code-server.dev/install.sh | sh -s -- --prefix=$VSCODE_DIR

# Create the directory inside the workspace where all code-server state will be stored
mkdir $VSCODE_DATA

# Install the Microsoft Python extension
code-server --install-extension ms-python.python