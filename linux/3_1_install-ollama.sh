#!/bin/bash

# Install Ollama in a persistent directory (see _wordslab-notebooks-env.bashrc)
mkdir $OLLAMA_DIR

# Download and uncompress the latest version of ollama
curl -L https://ollama.com/download/ollama-linux-amd64.tgz?version=0.5.5 -o ollama-linux-amd64.tgz
tar -C $OLLAMA_DIR -xzf ollama-linux-amd64.tgz
rm ollama-linux-amd64.tgz

# Add ollama to the path so that anyone can control it on the machine
echo '' >> ./_wordslab-notebooks-env.bashrc
echo '# Add tools the PATH' >> ./_wordslab-notebooks-env.bashrc
echo 'export PATH="$OLLAMA_DIR/bin:$PATH"' >> ./_wordslab-notebooks-env.bashrc

# Download small llama model for local inference
OLLAMA_HOME=0.0.0.0  $OLLAMA_DIR/bin/ollama serve &
pid=$!

# Wait for the server to be ready
while ! curl -s http://localhost:11434 > /dev/null; do
    sleep 1
done

if [ -f "$WORDSLAB_NOTEBOOKS_ENV/.cpu-only" ]; then
    $OLLAMA_DIR/bin/ollama pull llama3.2:1b
else
    $OLLAMA_DIR/bin/ollama pull llama3.2:3b
fi

kill $pid
