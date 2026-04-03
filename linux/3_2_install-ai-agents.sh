#!/bin/bash

# https://kilo.ai/docs/getting-started/installing#open-vsx-registry

$VSCODE_DIR/bin/code-server --install-extension kilocode.kilo-code@7.1.20 --extensions-dir $VSCODE_DATA/extensions

# https://github.com/mistralai/mistral-vibe?tab=readme-ov-file#using-uv

uv tool install mistral-vibe==2.7.2

# https://hermes-agent.nousresearch.com/docs/getting-started/installation
# https://hermes-agent.nousresearch.com/docs/user-guide/security

# TO DO - design a secure setup