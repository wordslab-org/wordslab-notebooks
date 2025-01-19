# Source this file in ~/.bashrc to configure the machine shell

# This version is updated on each release
export WORDSLAB_VERSION="2025-01"

# Detect the execution environment
if grep -qi microsoft /proc/version; then
    export WORDSLAB_PLATFORM="WindowsSubsystemForLinux"
elif [ -n "$MACHINE_ID" ] && [ -n "$MACHINE_NAME" ]; then
    export WORDSLAB_PLATFORM="Jarvislabs.ai"
elif [ -n "$RUNPOD_POD_ID" ] && [ -n "$RUNPOD_POD_HOSTNAME" ]; then
    export WORDSLAB_PLATFORM="Runpod.io"
elif [ -n "$CONTAINER_ID" ] && [ -n "$VAST_CONTAINER_LABEL" ]; then
    export WORDSLAB_PLATFORM="Vast.ai"
else
    export WORDSLAB_PLATFORM="UnknownLinux"
fi

# This must point to the mount path of a persistent volume inside the container
# Right now, all supported platforms can use the same path, but this could be platform dependent
export WORDSLAB_HOME=/home

# Install directories
export WORDSLAB_SCRIPTS=$WORDSLAB_HOME/wordslab-notebooks
export CONDA_DIR=$WORDSLAB_HOME/miniforge3

export WORDSLAB_NOTEBOOKS_ENV=$WORDSLAB_HOME/wordslab-notebooks-$WORDSLAB_VERSION
export VSCODE_DIR=$WORDSLAB_HOME/code-server
export OPENWEBUI_ENV=$WORDSLAB_HOME/open-webui-$WORDSLAB_VERSION
export OLLAMA_DIR=$WORDSLAB_HOME/ollama

# Data directories
export WORDSLAB_WORKSPACE=$WORDSLAB_HOME/workspace
export WORDSLAB_MODELS=$WORDSLAB_HOME/models

export JUPYTER_DATA=$WORDSLAB_WORKSPACE/.jupyter
export VSCODE_DATA=$WORDSLAB_WORKSPACE/.codeserver
export OPENWEBUI_DATA=$WORDSLAB_WORKSPACE/.openwebui

# Open web server ports
export DASHBOARD_PORT=8888

export JUPYTERLAB_PORT=8880
export VSCODE_PORT=8881
export OPENWEBUI_PORT=8882
# Note: ollama is not exposed to the outside worlds, it must be used from inside the container

# Reserved tools ports
export VLLM_PORT=8883
export GRADIO_PORT=8884
export ARGILLA_PORT=8085

# Additional open ports for 3 user defined applications
export USER_APP1_PORT=8086
export USER_APP2_PORT=8087
export USER_APP3_PORT=8089
