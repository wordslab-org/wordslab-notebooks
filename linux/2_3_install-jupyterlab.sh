#!/bin/bash

# Initialize the workspace directory
mkdir -p $WORDSLAB_WORKSPACE

# Also prepare a persistent directory to store the secrets used by all wordslab applications
mkdir -p $WORDSLAB_WORKSPACE/.secrets

if [ ! -f ~/.wordslab-installed ]; then

    # Configure Jupyterlab to store all its state under the $WORDSLAB_WORKSPACE directory (see _wordslab-notebooks-env.bashrc)
    echo '' >> ./_wordslab-notebooks-env.bashrc
    echo '# Jupyterlab notebooks data directories' >> ./_wordslab-notebooks-env.bashrc
    echo 'export JUPYTER_CONFIG_DIR=$JUPYTER_DATA/etc/jupyter' >> ./_wordslab-notebooks-env.bashrc
    echo 'export JUPYTER_DATA_DIR=$JUPYTER_DATA/share/jupyter' >> ./_wordslab-notebooks-env.bashrc
    echo 'export JUPYTER_RUNTIME_DIR=$JUPYTER_DATA/share/jupyter/runtime' >> ./_wordslab-notebooks-env.bashrc
    echo 'export JUPYTERLAB_SETTINGS_DIR=$JUPYTER_DATA/lab/user-settings' >> ./_wordslab-notebooks-env.bashrc
    echo 'export JUPYTERLAB_WORKSPACES_DIR=$JUPYTER_DATA/lab/workspaces' >> ./_wordslab-notebooks-env.bashrc
fi

# Create jupterlab environment
mkdir -p $JUPYTERLAB_ENV
cp ./2_3_jupyterlab-pyproject.toml $JUPYTERLAB_ENV/pyproject.toml

# Download Jupyterlab and all its extensions
cd $JUPYTERLAB_ENV
uv sync
