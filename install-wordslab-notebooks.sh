#!/bin/bash

# The installation directory, workspace directory, and models download directory can optionnaly be personalized as follows:
# WORDSLAB_HOME=/home WORDSLAB_WORKSPACE=/home/workspace WORDSLAB_MODELS=/home/models ./install-wordslab-notebooks.sh

# Set WORDSLAB_HOME to its default value if necessary

if [ -z "${WORDSLAB_HOME}" ]; then
    export WORDSLAB_HOME=/home
fi

# Download wordslab-notebooks scripts in a persistent directory

mkdir -p $WORDSLAB_HOME
cd $WORDSLAB_HOME

apt update && apt install -y curl unzip

curl -L -o wordslab-notebooks.zip https://github.com/wordslab-org/wordslab-notebooks/archive/refs/heads/main.zip
unzip wordslab-notebooks.zip
rm wordslab-notebooks.zip
mv wordslab-notebooks-main wordslab-notebooks

# Navigate to the linux directory where all the scripts live
cd $WORDSLAB_HOME/wordslab-notebooks/linux

# Overwrite the default environment variables with the script envrionment
BASHRC_FILE="./_wordslab-notebooks-env.bashrc"
# Backup the .bashrc file
cp "$BASHRC_FILE" "$BASHRC_FILE.bak"
# Iterate over environment variables
while IFS='=' read -r var value; do
  # Check if the variable already exists in the .bashrc file
  if grep -q "^${var}=" "$BASHRC_FILE"; then
    # Replace the line if the variable exists
    sed -i "s|^${var}=.*|${var}=${value}|" "$BASHRC_FILE"
    echo 'saved ${var}=${value} in $BASHRC_FILE'
  fi
done < <(env)

# Set the initial environment variables
source $BASHRC_FILE

# Make sure all the necessary Ubtunu packages are installed
./1__update-operating-system.sh

# Install the notebooks and code environment: Jupyterlab, VS Code server, Aider AI agent
./2__install-wordslab-notebooks.sh

# Install the chat and LLM environment: Open WebUI, Ollama
./3__install-open-webui.sh

# Update ~/.bashrc to start new shells in the right environment and directory
./1_3-configure-shell-environment.sh

echo ''
echo '-------------------'
echo 'END OF INSTALLATION'
echo '-------------------'
echo ''
echo 'To start wordslab-notebooks:'
echo ''
echo '> source ~/.bashrc'
echo '> $WORDSLAB_SCRIPTS/start-wordslab-notebooks.sh'
echo ''
