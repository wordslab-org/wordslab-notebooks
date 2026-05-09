#!/bin/bash

# Install Visual Studio Code server in a persistent directory (see _wordslab-notebooks-env.bashrc)
curl -fsSL https://code-server.dev/install.sh | sh -s -- --version 4.118.0 --method standalone --prefix $VSCODE_DIR

# Create the directory inside the workspace where all code-server state will be stored
mkdir -p $VSCODE_DATA

# Install the Microsoft Python extension
$VSCODE_DIR/bin/code-server --install-extension ms-python.python@2026.4.0 --extensions-dir $VSCODE_DATA/extensions

# Install Mermaid Support for Markdown Preview
$VSCODE_DIR/bin/code-server --install-extension bierner.markdown-mermaid@1.32.0 --extensions-dir $VSCODE_DATA/extensions
