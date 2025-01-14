#!/bin/bash

# Install Visual Studio Code server in a persistent directory (see _wordslab-notebooks-env.bashrc)
curl -fsSL https://code-server.dev/install.sh | sh -s -- --version 4.96.2 --method standalone --prefix $VSCODE_DIR

# Create the directory inside the workspace where all code-server state will be stored
mkdir $VSCODE_DATA

# Install the Microsoft Python extension
$VSCODE_DIR/bin/code-server --install-extension ms-python.python@2024.22.1 --extensions-dir $VSCODE_DATA/extensions

# Install the Continue AI code assistant
$VSCODE_DIR/bin/code-server --install-extension Continue.continue@0.9.250 --extensions-dir $VSCODE_DATA/extensions
