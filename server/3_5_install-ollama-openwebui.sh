mkdir $WORKSPACE_DIR/ollama
curl -L https://ollama.com/download/ollama-linux-amd64.tgz -o ollama-linux-amd64.tgz
tar -C $WORKSPACE_DIR/ollama -xzf ollama-linux-amd64.tgz
rm ollama-linux-amd64.tgz

echo 'export PATH="$WORKSPACE_DIR/ollama/bin:$PATH"' >> ~/wordslab-notebooks-environment.sh
