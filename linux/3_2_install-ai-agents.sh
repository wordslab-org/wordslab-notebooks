#!/bin/bash

# https://docs.cline.bot/getting-started/installing-cline#vscodium%2Fwindsurf

$VSCODE_DIR/bin/code-server --install-extension saoudrizwan.claude-dev@3.51.0 --extensions-dir $VSCODE_DATA/extensions

# https://kilo.ai/docs/getting-started/installing#open-vsx-registry

$VSCODE_DIR/bin/code-server --install-extension kilocode.kilo-code@4.149.0 --extensions-dir $VSCODE_DATA/extensions

# https://github.com/mistralai/mistral-vibe?tab=readme-ov-file#using-uv

uv tool install mistral-vibe