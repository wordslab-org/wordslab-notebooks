if ! pgrep -x "dockerd" > /dev/null; then
    service docker start
fi

code-server --auth none --bind-addr 0.0.0.0 --port $VSCODE_PORT --user-data-dir $WORKSPACE_DIR/.code-server --extensions-dir $WORKSPACE_DIR/.code-server/extensions --config $WORKSPACE_DIR/.code-server/config.yaml $WORKSPACE_DIR &
pid1=$!

jupyter lab -ServerApp.base_url="/" -ServerApp.ip=0.0.0.0 -ServerApp.port=$JUPYTERLAB_PORT -IdentityProvider.token="" --no-browser -ServerApp.allow_root=True -ServerApp.allow_remote_access=True -ServerApp.root_dir="$WORKSPACE_DIR" &
pid2=$!

# Define cleanup function to kill both commands
cleanup() {
  echo "Stopping commands..."
  kill $pid1 $pid2
}
# Trap SIGINT and call cleanup
trap cleanup SIGINT
# Wait for both processes to finish
wait $pid1 $pid2
