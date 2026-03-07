#!/bin/bash

# Install Visual Studio Code server in a persistent directory (see _wordslab-notebooks-env.bashrc)
curl -fsSL https://code-server.dev/install.sh | sh -s -- --version 4.109.5 --method standalone --prefix $VSCODE_DIR

# Create the directory inside the workspace where all code-server state will be stored
mkdir -p $VSCODE_DATA

# Install the Microsoft Python extension
$VSCODE_DIR/bin/code-server --install-extension ms-python.python@2026.2.0 --extensions-dir $VSCODE_DATA/extensions
