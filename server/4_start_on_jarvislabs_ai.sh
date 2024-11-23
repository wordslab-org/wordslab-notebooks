code-server --auth none --bind-addr 0.0.0.0 --port $VSCODE_PORT --user-data-dir $WORKSPACE_DIR/.code-server --extensions-dir $WORKSPACE_DIR/.code-server/extensions --config $WORKSPACE_DIR/.code-server/config.yaml $WORKSPACE_DIR &
pid1=$!

# Define cleanup function to kill both commands
cleanup() {
  echo "Stopping commands..."
  kill $pid1
}
# Trap SIGINT and call cleanup
trap cleanup SIGINT
