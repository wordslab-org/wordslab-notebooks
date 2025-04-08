#!/bin/bash

# Install Jupyterlab and its dependencies
pip install jupyterlab==4.4.0 ipympl==0.9.7

# Jupyterlab UI extension for git source code versioning
pip install jupyterlab-git==0.51.1

# Jupyterlab UI extensions for performance and compute resources monitoring
pip install jupyterlab_execute_time==3.2.0
pip install jupyterlab-nvdashboard==0.13.0 pynvml==12.0.0

# Install nbdev to enable the development of Python packages and documentation from Jupyter notebooks
pip install nbdev==2.4.2

# Install AI extension for Jupyter notebooks
pip install jupyter-ai==2.31.2 langchain-ollama==0.3.1 langchain-openai==0.3.12

# Configure Jupyterlab to store all its state under the $WORDSLAB_WORKSPACE directory (see _wordslab-notebooks-env.bashrc)

mkdir -p $WORDSLAB_WORKSPACE

echo '' >> ./_wordslab-notebooks-env.bashrc
echo '# Jupyterlab notebooks data directories' >> ./_wordslab-notebooks-env.bashrc
echo 'export JUPYTER_CONFIG_DIR=$JUPYTER_DATA/etc/jupyter' >> ./_wordslab-notebooks-env.bashrc
echo 'export JUPYTER_DATA_DIR=$JUPYTER_DATA/share/jupyter' >> ./_wordslab-notebooks-env.bashrc
echo 'export JUPYTER_RUNTIME_DIR=$JUPYTER_DATA/share/jupyter/runtime' >> ./_wordslab-notebooks-env.bashrc
echo 'export JUPYTERLAB_SETTINGS_DIR=$JUPYTER_DATA/lab/user-settings' >> ./_wordslab-notebooks-env.bashrc
echo 'export JUPYTERLAB_WORKSPACES_DIR=$JUPYTER_DATA/lab/workspaces' >> ./_wordslab-notebooks-env.bashrc

# Also prepare a persistent directory to store the secrets used by all wordslab applications
mkdir -p $WORDSLAB_WORKSPACE/.secrets
