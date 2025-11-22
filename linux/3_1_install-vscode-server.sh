#!/bin/bash

# Install Visual Studio Code server in a persistent directory (see _wordslab-notebooks-env.bashrc)
# WARNING: starting with vscode 4.105 and 4.106, a new github agents UI is conflicting with continue.dev extension visually, and this UI does not work with code-server out of the box
# https://coder.com/docs/code-server/FAQ#why-cant-code-server-use-microsofts-extension-marketplace
# https://github.com/coder/coder/issues/16838#issuecomment-2705570870
# https://github.com/coder/code-server/discussions/5063#discussioncomment-14377156
# => staying on version 4.104.3 (August 2025 recovery 3) for now
curl -fsSL https://code-server.dev/install.sh | sh -s -- --version 4.104.3 --method standalone --prefix $VSCODE_DIR

# Create the directory inside the workspace where all code-server state will be stored
mkdir -p $VSCODE_DATA

# Install the Microsoft Python extension
$VSCODE_DIR/bin/code-server --install-extension ms-python.python@2025.16.0 --extensions-dir $VSCODE_DATA/extensions

# Install the Continue AI code assistant
CONTINUE_GLOBAL_DIR=$VSCODE_DATA/.continue $VSCODE_DIR/bin/code-server --install-extension Continue.continue@1.2.11 --extensions-dir $VSCODE_DATA/extensions
