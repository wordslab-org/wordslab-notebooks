# Source this file in ~/.bashrc to configure the machine shell

# This version is updated on install by ../install-wordslab-notebooks.sh
export WORDSLAB_VERSION=main

# Detect the execution environment
if grep -qi microsoft /proc/version; then
    export WORDSLAB_PLATFORM="WindowsSubsystemForLinux"
elif [ -n "$MACHINE_ID" ] && [ -n "$MACHINE_NAME" ]; then
    export WORDSLAB_PLATFORM="Jarvislabs.ai"
elif [ -n "$RUNPOD_POD_ID" ]; then
    export WORDSLAB_PLATFORM="Runpod.io"
elif [ -n "$VAST_TCP_PORT_22" ]; then
    export WORDSLAB_PLATFORM="Vast.ai"
else
    export WORDSLAB_PLATFORM="UnknownLinux"
fi

# This must point to the mount path of a persistent volume inside the container
# This is the default value, but it can be platform dependent
# It will be overwritten by user defined environment variables in install-wordslab-notebooks.sh
export WORDSLAB_HOME=/home

# Install directories
export WORDSLAB_SCRIPTS=$WORDSLAB_HOME/wordslab-notebooks-$WORDSLAB_VERSION

export JUPYTERLAB_ENV=$WORDSLAB_HOME/jupyterlab
export VSCODE_DIR=$WORDSLAB_HOME/code-server
export OPENWEBUI_ENV=$WORDSLAB_HOME/open-webui
export OLLAMA_DIR=$WORDSLAB_HOME/ollama

# Data directories
export WORDSLAB_WORKSPACE=$WORDSLAB_HOME/workspace
export WORDSLAB_MODELS=$WORDSLAB_HOME/models

export JUPYTER_DATA=$WORDSLAB_WORKSPACE/.jupyter
export VSCODE_DATA=$WORDSLAB_WORKSPACE/.codeserver
export OPENWEBUI_DATA=$WORDSLAB_WORKSPACE/.openwebui

# Python global directories
export UV_INSTALL_DIR=$WORDSLAB_HOME/python
export UV_PYTHON_INSTALL_DIR=$UV_INSTALL_DIR
export UV_PYTHON_BIN_DIR=$UV_INSTALL_DIR
export UV_CACHE_DIR=$UV_INSTALL_DIR
if [ -v UV_NO_CACHE ]; then
    unset UV_NO_CACHE
fi
export UV_LINK_MODE="symlink"
export UV_TOOL_DIR=$UV_INSTALL_DIR/tools 
export UV_TOOL_BIN_DIR=$UV_INSTALL_DIR

# Optional Docling documents extractions
export OPENWEBUI_START_DOCLING=no # 'yes' or 'no' to start OpenWebUI with Docling support - 5 GB VRAM used
export DOCLING_ENV=$WORDSLAB_HOME/docling
export DOCLING_DATA=$WORDSLAB_WORKSPACE/.docling
export DOCLING_MODELS=$WORDSLAB_MODELS/docling

# Open ports for wordslab-notebooks built-in applications
export DASHBOARD_PORT=8888
export JUPYTERLAB_PORT=8880
export VSCODE_PORT=8881
export OPENWEBUI_PORT=8882

# Note: ollama and docling are not exposed to the outside world
# => they must be used from inside the container
# ... used by Aider
export OLLAMA_API_BASE=http://127.0.0.1:11434
# ... used by Open WebUI
export DOCLING_SERVER_URL=http://127.0.0.1:5001

# Additional open ports for 5 user defined applications
export USER_APP1_PORT=8883
export USER_APP2_PORT=8884
export USER_APP3_PORT=8885
export USER_APP4_PORT=8886
export USER_APP5_PORT=8887


