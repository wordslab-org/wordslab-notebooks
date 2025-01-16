#!/bin/bash

# Start Docker only if we are not already inside a Docker container ...
if [ ! -f /.dockerenv ]; then
    # ... and if the Docker daemon is not already running
    if ! pgrep -x "dockerd" > /dev/null; then
        service docker start
    fi
fi

# Start Visual Studio Code server
$VSCODE_DIR/bin/code-server --auth none --bind-addr 0.0.0.0 --port $VSCODE_PORT --user-data-dir $VSCODE_DATA --extensions-dir $VSCODE_DATA/extensions --config $VSCODE_DATA/config.yaml $WORDSLAB_WORKSPACE &
pid1=$!

# Start Jupyterlab server
export JUPYTER_ALLOW_INSECURE_WRITES=true
jupyter lab -ServerApp.base_url="/" -ServerApp.ip=0.0.0.0 -ServerApp.port=$JUPYTERLAB_PORT -IdentityProvider.token="" --no-browser -ServerApp.allow_root=True -ServerApp.allow_remote_access=True -ServerApp.root_dir="$WORDSLAB_WORKSPACE" &
pid2=$!

# Start ollama server
OLLAMA_HOME=0.0.0.0 OLLAMA_LOAD_TIMEOUT=-1 ollama serve &
pid3=$!

# Start open-webui server
source <("$CONDA_DIR/bin/conda" 'shell.bash' 'hook' 2> /dev/null)
conda activate $OPENWEBUI_ENV

if [ -f "$WORDSLAB_NOTEBOOKS_ENV/.cpu-only" ]; then
    export USE_CUDA_DOCKER="false"
else
    export USE_CUDA_DOCKER="true"
fi

ENV=prod WEBUI_AUTH=false WEBUI_URL=http://localhost:$OPENWEBUI_PORT DATA_DIR=$OPENWEBUI_DATA FUNCTIONS_DIR=$OPENWEBUI_DATA/functions TOOLS_DIR=$OPENWEBUI_DATA/tools open-webui serve --host 0.0.0.0 --port $OPENWEBUI_PORT &
pid4=$!
conda deactivate

# Start wordslab notebooks dashboard

cd $WORDSLAB_SCRIPTS/dashboard
./start-dashboard.sh &
pid5=$!

echo ''
echo '------------------'
echo 'Open the DASHBOARD'
echo '------------------'
echo ''
echo http://127.0.0.1:$DASHBOARD_PORT
echo ''
echo '------------------'
echo ''

# Define cleanup function to kill all commands
cleanup() {
  echo "Stopping all servers..."
  kill $pid1 $pid2 $pid3 $pid4 $pid5
}
# Trap SIGINT and call cleanup
trap cleanup SIGINT
# Wait for all processes to finish
wait $pid1 $pid2 $pid3 $pid4 $pid5
