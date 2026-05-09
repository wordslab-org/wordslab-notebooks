#!/bin/bash

# kilocode uses XDG_CACHE_HOME, XDG_CONFIG_HOME, XDG_DATA_HOME already set in the environment
# mistral vibe install directory is hardcoded depending based on uv tool install target directory

mkdir -p $WORDSLAB_WORKSPACE/.hermes
mkdir -p $WORDSLAB_WORKSPACE/.vibe

echo '' >> ./_wordslab-notebooks-env.bashrc
echo '# Agents data directories' >> ./_wordslab-notebooks-env.bashrc
echo 'export VIBE_HOME=$WORDSLAB_WORKSPACE/.vibe' >> ./_wordslab-notebooks-env.bashrc
echo 'export HERMES_INSTALL_DIR=$WORDSLAB_HOME/hermes-agent' >> ./_wordslab-notebooks-env.bashrc
echo 'export HERMES_HOME=$WORDSLAB_WORKSPACE/.hermes' >> ./_wordslab-notebooks-env.bashrc

source ./_wordslab-notebooks-env.bashrc

# https://kilo.ai/docs/getting-started/installing#open-vsx-registry

$VSCODE_DIR/bin/code-server --install-extension kilocode.kilo-code@7.2.40 --extensions-dir $VSCODE_DATA/extensions

# https://github.com/mistralai/mistral-vibe?tab=readme-ov-file#using-uv

uv tool install mistral-vibe==2.9.5

# https://hermes-agent.nousresearch.com/docs/getting-started/installation
# https://hermes-agent.nousresearch.com/docs/user-guide/security

curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash -s -- --skip-setup
source ~/.bashrc

# Needs [boot]systemd=true in wsl.conf
$HOME/.local/bin/hermes config set API_SERVER_ENABLED true 
$HOME/.local/bin/hermes config set API_SERVER_KEY wordslab-notebooks-hermes-agent
$HOME/.local/bin/hermes gateway install