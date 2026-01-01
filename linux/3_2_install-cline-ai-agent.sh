#!/bin/bash

# https://docs.cline.bot/getting-started/installing-cline#vscodium%2Fwindsurf

$VSCODE_DIR/bin/code-server --install-extension saoudrizwan.claude-dev@3.46.1 --extensions-dir $VSCODE_DATA/extensions

# https://docs.cline.bot/cline-cli/installation
# https://nodejs.org/en/download

# Download and install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$HOME/.nvm/nvm.sh"

# Download and install Node.js: cline recommends using Node.js 22 for the best experience
nvm install 22

# Install cline CLI
npm install -g cline@1.0.8

# Installing also kilo code until we choose one coding agent 

$VSCODE_DIR/bin/code-server --install-extension kilocode.kilo-code@4.141.1 --extensions-dir $VSCODE_DATA/extensions