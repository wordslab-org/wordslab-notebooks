#!/bin/bash

# If the container root file system was reset after we restart an instance
# we need to reinstall the operating system packages and re configure the shell
if [ ! -f "/.wordslab-$WORDSLAB_VERSION-installed" ]; then
    # Install or update all the required Linux packages 
    ./1__update-operating-system.sh
fi

# Start Docker only if we are not already inside a Docker container ...
if [ ! -f /.dockerenv ]; then
    # ... and if the Docker daemon is not already running
    if ! pgrep -x "dockerd" > /dev/null; then
        service docker start
    fi
fi

# Start Visual Studio Code server
code-server --auth none --bind-addr 0.0.0.0 --port $VSCODE_PORT --user-data-dir $VSCODE_DATA --extensions-dir $VSCODE_DATA/extensions --config $VSCODE_DATA/config.yaml $WORDSLAB_WORKSPACE &
pid1=$!

# Start Jupyterlab server
jupyter lab -ServerApp.base_url="/" -ServerApp.ip=0.0.0.0 -ServerApp.port=$JUPYTERLAB_PORT -IdentityProvider.token="" --no-browser -ServerApp.allow_root=True -ServerApp.allow_remote_access=True -ServerApp.root_dir="$WORDSLAB_WORKSPACE" &
pid2=$!

# Start ollama server
OLLAMA_HOME=0.0.0.0  ollama serve &
pid3=$!

# Start open-webui server
conda activate $OPENWEBUI_ENV
ENV=prod WEBUI_AUTH=false WEBUI_URL=http://localhost:$OPENWEBUI_PORT DATA_DIR=$OPENWEBUI_DATA FUNCTIONS_DIR=$OPENWEBUI_DATA/functions TOOLS_DIR=$OPENWEBUI_DATA/tools open-webui serve --host 0.0.0.0 --port OPENWEBUI_PORT &
pid4=$!
conda deactivate

# Define cleanup function to kill all commands
cleanup() {
  echo "Stopping all servers..."
  kill $pid1 $pid2 $pid3 $pid4
}
# Trap SIGINT and call cleanup
trap cleanup SIGINT
# Wait for all processes to finish
wait $pid1 $pid2 $pid3 $pid4