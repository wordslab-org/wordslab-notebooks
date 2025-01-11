#!/bin/bash

# Download wordslab-notebooks scripts in a persistent directory

export $WORDSLAB_HOME=/home

mkdir -p $WORDSLAB_HOME
cd $WORDSLAB_HOME

apt update && apt install curl unzip

curl -L -o wordslab-notebooks.zip https://github.com/wordslab-org/wordslab-notebooks/archive/refs/heads/main.zip
unzip wordslab-notebooks.zip
rm wordslab-notebooks.zip
mv wordslab-notebooks-main wordslab-notebooks

# Navigate to the linux directory where all the scripts live
cd wordslab-notebooks/linux

# Set the initial environment variables
source ./_wordslab-notebooks-env.bashrc

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
