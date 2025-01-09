#!/bin/bash

# Navigate to the linux directory where all the scripts live
cd linux

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
echo 'To start all servers:'
echo ''
echo '> source ~/.bashrc'
echo '> ~/start-wordslab-notebooks.sh'
echo ''
