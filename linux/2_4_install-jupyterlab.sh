#!/bin/bash

# Install Jupyterlab and its dependencies
pip install jupyterlab==4.3.4 ipympl==0.9.5

# Jupyterlab UI extension for git source code versioning
pip install jupyterlab-git==0.50.2

# Jupyterlab UI extensions for performance and compute resources monitoring
pip install jupyterlab_execute_time==3.2.0
pip install jupyterlab-nvdashboard==0.11.00 pynvml==11.5.3

# Install nbdev to enable the development of Python packages and documentation from Jupyter notebooks
pip install nbdev==2.3.34

# Install AI extension for Jupyter notebooks
pip install jupyter-ai==2.28.4 langchain-ollama==0.1.3 langchain-openai==0.1.24

# Configure Jupyterlab to store all its state under the $WORDSLAB_WORKSPACE directory (see _wordslab-notebooks-env.bashrc)

mkdir -p $WORDSLAB_WORKSPACE

echo '' >> ./_wordslab-notebooks-env.bashrc
echo '# Jupyterlab notebooks data directories' >> ./_wordslab-notebooks-env.bashrc
echo 'export JUPYTER_CONFIG_DIR=$WORDSLAB_WORKSPACE/.jupyter/etc/jupyter' >> ./_wordslab-notebooks-env.bashrc
echo 'export JUPYTER_DATA_DIR=$WORDSLAB_WORKSPACE/.jupyter/share/jupyter' >> ./_wordslab-notebooks-env.bashrc
echo 'export JUPYTER_RUNTIME_DIR=$WORDSLAB_WORKSPACE/.jupyter/share/jupyter/runtime' >> ./_wordslab-notebooks-env.bashrc
echo 'export JUPYTERLAB_SETTINGS_DIR=$WORDSLAB_WORKSPACE/.jupyter/lab/user-settings' >> ./_wordslab-notebooks-env.bashrc
echo 'export JUPYTERLAB_WORKSPACES_DIR=$WORDSLAB_WORKSPACE/.jupyter/lab/workspaces' >> ./_wordslab-notebooks-env.bashrc
