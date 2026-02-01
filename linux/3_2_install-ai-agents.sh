#!/bin/bash

# https://docs.cline.bot/getting-started/installing-cline#vscodium%2Fwindsurf

$VSCODE_DIR/bin/code-server --install-extension saoudrizwan.claude-dev@3.56.2 --extensions-dir $VSCODE_DATA/extensions

# https://kilo.ai/docs/getting-started/installing#open-vsx-registry

$VSCODE_DIR/bin/code-server --install-extension kilocode.kilo-code@5.2.2 --extensions-dir $VSCODE_DATA/extensions

# https://github.com/mistralai/mistral-vibe?tab=readme-ov-file#using-uv

uv tool install mistral-vibe==2.0.2

# https://opencode.ai/

curl -fsSL https://opencode.ai/install | bash -s -- --version 1.1.48