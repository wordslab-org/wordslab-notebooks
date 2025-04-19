#!/bin/bash

# Create the directory inside the workspace where all Open WebUI state will be stored

mkdir $OPENWEBUI_DATA
mkdir $OPENWEBUI_DATA/functions
mkdir $OPENWEBUI_DATA/tools

# Create a dedicated conda environment to install Open WebUI and its dependencies
# The files are stored in an independent and persistent directory: $WORDSLAB_NOTEBOOKS_ENV (see _wordslab-notebooks-env.bashrc)

source <("$CONDA_DIR/bin/conda" 'shell.bash' 'hook' 2> /dev/null)

conda create -y --prefix $OPENWEBUI_ENV python==3.12.10
conda activate $OPENWEBUI_ENV

pip install open-webui==0.6.5

# Patch Open WebUI to enable HTTPS secure access
OPENWEBUI_SERVER_FILE="$OPENWEBUI_ENV/lib/python3.12/site-packages/open_webui/__init__.py"
sed -i 's/port: int = 8080,/port: int = 8080, ssl_keyfile: str = None, ssl_certfile: str = None,/g' "$OPENWEBUI_SERVER_FILE"
sed -i 's/port=port,/port=port, ssl_keyfile=ssl_keyfile, ssl_certfile=ssl_certfile,/g' "$OPENWEBUI_SERVER_FILE"

# Initialize the Open WebUI installation

# Need to set HF_HOME before downloading the embedding & reranking models
source ./_wordslab-notebooks-env.bashrc

if [ -f "$WORDSLAB_NOTEBOOKS_ENV/.cpu-only" ]; then
    export USE_CUDA_DOCKER="false"
else
    export USE_CUDA_DOCKER="true"
fi
DATA_DIR=$OPENWEBUI_DATA FUNCTIONS_DIR=$OPENWEBUI_DATA/functions TOOLS_DIR=$OPENWEBUI_DATA/tools DEFAULT_MODELS="$OLLAMA_CHAT_MODEL" RAG_EMBEDDING_ENGINE="ollama" RAG_EMBEDDING_MODEL="$OLLAMA_EMBED_MODEL" python -c "import open_webui.main"

conda deactivate
