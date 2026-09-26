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

$VSCODE_DIR/bin/code-server --install-extension kilocode.kilo-code@7.8.1 --extensions-dir $VSCODE_DATA/extensions

# https://github.com/mistralai/mistral-vibe?tab=readme-ov-file#using-uv

uv tool install mistral-vibe==2.25.8

# https://hermes-agent.nousresearch.com/docs/getting-started/installation
# https://hermes-agent.nousresearch.com/docs/user-guide/security

# First install a standalone Node.js version
mkdir $HOME/.nvm && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | NVM_DIR=$HOME/.nvm bash
\. "$HOME/.nvm/nvm.sh"
nvm install 24

# Then install Hermes agent
ln -s "$UV_INSTALL_DIR/uv" "$WORDSLAB_WORKSPACE/.hermes/bin/uv" # workaround for recent uv versions deadlock
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash -s -- --skip-setup
source ~/.bashrc

# Needs [boot]systemd=true in wsl.conf
timeout 30 bash -c 'while true; do state=$(systemctl is-system-running); echo "$state"; [[ "$state" != "running" && "$state" != "degraded" ]] || break; sleep 5; done' # necessary warmup - in WSL the D-Bus daemon sometimes hangs longer than 5 sec
systemctl is-system-running

cd $WORDSLAB_HOME/hermes-agent/
HASH=$(python -c "from plugins.dashboard_auth.basic import hash_password; print(hash_password('hermes-agent'))")
$HOME/.local/bin/hermes config set HERMES_DASHBOARD_BASIC_AUTH_USERNAME admin
$HOME/.local/bin/hermes config set HERMES_DASHBOARD_BASIC_AUTH_PASSWORD_HASH $HASH
$HOME/.local/bin/hermes config set HERMES_DASHBOARD_BASIC_AUTH_SECRET $(openssl rand -base64 32)
$HOME/.local/bin/hermes config set API_SERVER_ENABLED true 
$HOME/.local/bin/hermes config set API_SERVER_KEY wordslab-notebooks-hermes-agent
$HOME/.local/bin/hermes gateway install
$HOME/.local/bin/hermes gateway start
$HOME/.local/bin/hermes gateway status