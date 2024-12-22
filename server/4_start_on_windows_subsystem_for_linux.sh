if ! pgrep -x "dockerd" > /dev/null; then
    service docker start
fi

code-server --auth none --bind-addr 0.0.0.0 --port $VSCODE_PORT --user-data-dir $WORKSPACE_DIR/.code-server --extensions-dir $WORKSPACE_DIR/.code-server/extensions --config $WORKSPACE_DIR/.code-server/config.yaml $WORKSPACE_DIR &
pid1=$!

jupyter lab -ServerApp.base_url="/" -ServerApp.ip=0.0.0.0 -ServerApp.port=$JUPYTERLAB_PORT -IdentityProvider.token="" --no-browser -ServerApp.allow_root=True -ServerApp.allow_remote_access=True -ServerApp.root_dir="$WORKSPACE_DIR" &
pid2=$!

OLLAMA_HOME=0.0.0.0  $WORKSPACE_DIR/ollama/bin/ollama serve &
pid3=$!

conda activate openwebui-2024-12
ENV=prod WEBUI_AUTH=false WEBUI_URL=http://localhost:8080 DATA_DIR=$WORKSPACE_DIR/open-webui FUNCTIONS_DIR=$WORKSPACE_DIR/open-webui/functions TOOLS_DIR=$WORKSPACE_DIR/open-webui/tools open-webui serve --host 0.0.0.0 --port 8080 &
pid4=$!
conda deactivate

# Define cleanup function to kill all commands
cleanup() {
  echo "Stopping commands..."
  kill $pid1 $pid2 $pid3 $pid4
}
# Trap SIGINT and call cleanup
trap cleanup SIGINT
# Wait for all processes to finish
wait $pid1 $pid2 $pid3 $pid4
