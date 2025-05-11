#!/bin/bash

# Create the directory inside the workspace where all Open WebUI state will be stored

mkdir -p $OPENWEBUI_DATA
mkdir -p $OPENWEBUI_DATA/functions
mkdir -p $OPENWEBUI_DATA/tools

# Create the OpenWebUI environment
mkdir -p $OPENWEBUI_ENV
cp ./4_2_openwebui-pyproject.toml $OPENWEBUI_ENV/pyproject.toml

# Download Jupyterlab and all its extensions
cd $OPENWEBUI_ENV
if [ -f "$WORDSLAB_WORKSPACE/.cpu-only" ]; then
    uv sync --extra cpu
else
    uv sync --extra cuda
fi

# Patch Open WebUI to enable HTTPS secure access
OPENWEBUI_SERVER_FILE="$OPENWEBUI_ENV/.venv/lib/python3.12/site-packages/open_webui/__init__.py"
if ! grep -q 'ssl_keyfile: str = None,' "$OPENWEBUI_SERVER_FILE"; then
    sed -i 's/port: int = 8080,/port: int = 8080, ssl_keyfile: str = None, ssl_certfile: str = None,/g' "$OPENWEBUI_SERVER_FILE"
    sed -i 's/port=port,/port=port, ssl_keyfile=ssl_keyfile, ssl_certfile=ssl_certfile,/g' "$OPENWEBUI_SERVER_FILE"
fi

# Initialize the Open WebUI installation

# Need to set HF_HOME before downloading the embedding & reranking models
source $WORDSLAB_SCRIPTS/linux/_wordslab-notebooks-env.bashrc

source .venv/bin/activate
if [ -f "$WORDSLAB_NOTEBOOKS_ENV/.cpu-only" ]; then
    export USE_CUDA_DOCKER="false"
else
    export USE_CUDA_DOCKER="true"
fi
DATA_DIR=$OPENWEBUI_DATA FUNCTIONS_DIR=$OPENWEBUI_DATA/functions TOOLS_DIR=$OPENWEBUI_DATA/tools DEFAULT_MODELS="$OLLAMA_CHAT_MODEL" RAG_EMBEDDING_ENGINE="ollama" RAG_EMBEDDING_MODEL="$OLLAMA_EMBED_MODEL" python -c "import open_webui.main"
