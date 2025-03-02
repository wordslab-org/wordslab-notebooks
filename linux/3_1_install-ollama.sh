#!/bin/bash

# Install Ollama in a persistent directory (see _wordslab-notebooks-env.bashrc)
mkdir $OLLAMA_DIR

# Download and uncompress the latest version of ollama
curl -L https://ollama.com/download/ollama-linux-amd64.tgz?version=0.5.13-rc2 -o ollama-linux-amd64.tgz
tar -C $OLLAMA_DIR -xzf ollama-linux-amd64.tgz
rm ollama-linux-amd64.tgz

# Add ollama to the path so that anyone can control it on the machine
echo '' >> ./_wordslab-notebooks-env.bashrc
echo '# Add tools the PATH' >> ./_wordslab-notebooks-env.bashrc
echo 'export PATH="$OLLAMA_DIR/bin:$PATH"' >> ./_wordslab-notebooks-env.bashrc

# Need to set OLLAMA_HOME before downloading the language model
source ./_wordslab-notebooks-env.bashrc

# Download small llama model for local inference
OLLAMA_HOME=0.0.0.0  $OLLAMA_DIR/bin/ollama serve &
pid=$!

# Wait for the server to be ready
while ! curl -s http://localhost:11434 > /dev/null; do
    sleep 1
done

# Choose a default local LLMs for this machine
if [ -f "$WORDSLAB_NOTEBOOKS_ENV/.cpu-only" ]; then
    OLLAMA_CHAT_MODEL="llama3.2:1b"
    OLLAMA_CODE_MODEL="qwen2.5-coder:0.5b-base"
else
    OLLAMA_CHAT_MODEL="phi4-mini"
    OLLAMA_CODE_MODEL="qwen2.5-coder:1.5b-base"
fi
OLLAMA_EMBED_MODEL="nomic-embed-text"

# Save the LLM names as env variables 
echo '' >> ./_wordslab-notebooks-env.bashrc
echo '# Default ollama model' >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_CHAT_MODEL=$OLLAMA_CHAT_MODEL" >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_CODE_MODEL=$OLLAMA_CODE_MODEL" >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_EMBED_MODEL=$OLLAMA_EMBED_MODEL" >> ./_wordslab-notebooks-env.bashrc

# Download the default local LLMs
$OLLAMA_DIR/bin/ollama pull $OLLAMA_CHAT_MODEL
$OLLAMA_DIR/bin/ollama pull $OLLAMA_CODE_MODEL
$OLLAMA_DIR/bin/ollama pull $OLLAMA_EMBED_MODEL

# Configure models for VsCode extension Continue.dev
sed -i "/\"models\": \[\],/c\
\"models\": [\
    {\
      \"title\": \"$OLLAMA_CHAT_MODEL\",\
      \"provider\": \"ollama\",\
      \"model\": \"$OLLAMA_CHAT_MODEL\"\
    }\
  ],\
  \"tabAutocompleteModel\": {\
    \"title\": \"$OLLAMA_CODE_MODEL\",\
    \"provider\": \"ollama\",\
    \"model\": \"$OLLAMA_CODE_MODEL\"\
  },\
  \"embeddingsProvider\": {\
    \"provider\": \"ollama\",\
    \"model\": \"$OLLAMA_EMBED_MODEL\"\
  }," $VSCODE_DATA/.continue/config.json

kill $pid
