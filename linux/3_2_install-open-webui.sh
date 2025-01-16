#!/bin/bash

# Create the directory inside the workspace where all Open WebUI state will be stored

mkdir $OPENWEBUI_DATA
mkdir $OPENWEBUI_DATA/functions
mkdir $OPENWEBUI_DATA/tools

# Create a dedicated conda environment to install Open WebUI and its dependencies
# The files are stored in an independent and persistent directory: $WORDSLAB_NOTEBOOKS_ENV (see _wordslab-notebooks-env.bashrc)

source <("$CONDA_DIR/bin/conda" 'shell.bash' 'hook' 2> /dev/null)

conda create -y --prefix $OPENWEBUI_ENV python==3.12.8
conda activate $OPENWEBUI_ENV

pip install open-webui==0.5.4

# Initialize the Open WebUI installation
# Need to set HF_HOME before downloading the embedding & reranking models

source ./_wordslab-notebooks-env.bashrc
DATA_DIR=$OPENWEBUI_DATA FUNCTIONS_DIR=$OPENWEBUI_DATA/functions TOOLS_DIR=$OPENWEBUI_DATA/tools python -c "import open_webui.main"

conda deactivate
