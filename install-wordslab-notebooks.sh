#!/bin/bash

# The installation directory, workspace directory, and models download directory can optionnaly be personalized as follows:
# WORDSLAB_HOME=/home WORDSLAB_WORKSPACE=/home/workspace WORDSLAB_MODELS=/home/models ./install-wordslab-notebooks.sh

# Set WORDSLAB_HOME to its default value if necessary
if [ -z "${WORDSLAB_HOME}" ]; then
    export WORDSLAB_HOME="/home"
fi
# Set WORDSLAB_VERSION to its default value if necessary
if [ -z "${WORDSLAB_VERSION}" ]; then
    export WORDSLAB_VERSION="2025-05"
fi

# Download wordslab-notebooks scripts in a persistent directory

mkdir -p $WORDSLAB_HOME
cd $WORDSLAB_HOME

apt update && apt install -y curl unzip

if [ "$WORDSLAB_VERSION" == "main" ]; then
  curl -L -o wordslab-notebooks.zip https://github.com/wordslab-org/wordslab-notebooks/archive/refs/heads/main.zip
else
  curl -L -o wordslab-notebooks.zip https://github.com/wordslab-org/wordslab-notebooks/archive/refs/tags/${WORDSLAB_VERSION}.zip
fi
unzip wordslab-notebooks.zip
rm wordslab-notebooks.zip

# Navigate to the linux directory where all the scripts live
cd $WORDSLAB_HOME/wordslab-notebooks-$WORDSLAB_VERSION/linux

# Overwrite the default environment variables with the script envrionment
BASHRC_FILE="./_wordslab-notebooks-env.bashrc"
# Backup the .bashrc file
cp "$BASHRC_FILE" "$BASHRC_FILE.bak"
# Iterate over environment variables
while IFS='=' read -r var value; do
  # Check if the variable already exists in the .bashrc file
  if grep -q "^export ${var}=" "$BASHRC_FILE"; then
    # Replace the line if the variable exists
    sed -i "s|^export ${var}=.*|export ${var}=${value}|" "$BASHRC_FILE"
    echo "saved ${var}=${value} in $BASHRC_FILE"
  fi
done < <(env)

# Set the initial environment variables
source $BASHRC_FILE

# Make sure all the necessary Ubtunu packages are installed
./1__update-operating-system.sh

# Install the notebooks environment: Python, dahsboard, Jupyterlab, projects, datascience librairies
./2__install-wordslab-notebooks.sh

# Make sure the python package manager is available for the following scripts
source $UV_INSTALL_DIR/env

# Install the code environment: VS Code server, Aider AI agent
./3__install-vscode-server.sh

# Install the chat and LLM environment: Open WebUI, Ollama
./4__install-open-webui.sh

# Update ~/.bashrc to start new shells in the right environment and directory
./1_3_configure-shell-environment.sh

# Set up default startup script with the right path
echo "cd $WORDSLAB_HOME/wordslab-notebooks-$WORDSLAB_VERSION && ./start-wordslab-notebooks.sh" > $WORDSLAB_HOME/start-wordslab-notebooks.bat

echo ''
echo '-------------------'
echo 'END OF INSTALLATION'
echo '-------------------'
echo ''
echo 'To start wordslab-notebooks:'
echo ''
if [ -f /home/.WORDSLAB_WINDOWS_HOME ]; then
    vm_path=$(< /home/.WORDSLAB_WINDOWS_HOME)
    wordslab_path="${vm_path%\\*\\*}"
    echo "cd $wordslab_path"
    echo "start-wordslab-notebooks.bat"
else
    echo "cd $WORDSLAB_HOME"
    echo "./start-wordslab-notebooks.sh"
fi
