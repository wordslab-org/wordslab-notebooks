#!/bin/bash

# Install Ollama in a persistent directory (see _wordslab-notebooks-env.bashrc)
mkdir $OLLAMA_DIR

# Download and uncompress the latest version of ollama
curl -L https://ollama.com/download/ollama-linux-amd64.tgz?version=0.6.3 -o ollama-linux-amd64.tgz
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
    # Get the GPU VRAM in MiB and choose the best chat model which fits in memory
    vram_gib=$(nvidia-smi --query-gpu=memory.total --format=csv,nounits,noheader | awk '{print int($1 / 1024)}')
    if [ "$vram_gib" -ge 23 ]; then        
        OLLAMA_CHAT_MODEL="gemma3:27b"
    elif [ "$vram_gib" -ge 15 ]; then
        OLLAMA_CHAT_MODEL="gemma3:12b"
    else
        OLLAMA_CHAT_MODEL="gemma3:4b"
    fi
    OLLAMA_CODE_MODEL="qwen2.5-coder:1.5b-base"
fi
OLLAMA_EMBED_MODEL="nomic-embed-text:latest"

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

# Stop ollama
kill $pid

# Configure models for Jupyter AI extension

JAI_CONFIG_FILE="$JUPYTER_DATA_DIR/jupyter_ai/config.json"
mkdir -p "$(dirname "$JAI_CONFIG_FILE")"
cat > "$JAI_CONFIG_FILE" <<EOF
{
    "model_provider_id": "ollama:$OLLAMA_CHAT_MODEL",
    "embeddings_provider_id": "ollama:$OLLAMA_EMBED_MODEL",
    "send_with_shift_enter": false,
    "fields": {},
    "api_keys": {},
    "completions_model_provider_id": "ollama:$OLLAMA_CODE_MODEL",
    "completions_fields": {}
}
EOF

JIC_CONFIG_FILE="$JUPYTERLAB_SETTINGS_DIR/@jupyterlab/completer-extension/inline-completer.jupyterlab-settings"
mkdir -p "$(dirname "$JIC_CONFIG_FILE")"
cat > "$JIC_CONFIG_FILE" <<EOF
{
    "providers": {
        "@jupyterlab/inline-completer:history": {
            "enabled": false,
            "timeout": 5000,
            "debouncerDelay": 0,
            "maxSuggestions": 100
        },
        "@jupyterlab/jupyter-ai": {
            "enabled": true,
            "timeout": 5000,
            "debouncerDelay": 250,
            "triggerKind": "any",
            "maxPrefix": 10000,
            "maxSuffix": 10000,
            "disabledLanguages": [
                "ipythongfm"
            ],
            "streaming": "manual"
        }
    },
    "showWidget": "onHover",
    "showShortcuts": true,
    "suppressIfTabCompleterActive": true,
    "streamingAnimation": "uncover",
    "minLines": 0,
    "maxLines": 0,
    "reserveSpaceForLongest": false,
    "editorResizeDelay": 1000
}
EOF

# Configure models for VsCode extension Continue.dev

CONT_CONFIG_FILE="$VSCODE_DATA/.continue/config.json"
mkdir -p "$(dirname "$CONT_CONFIG_FILE")"
cat > "$CONT_CONFIG_FILE" <<EOF
{
  "models": [
    {
      "title": "$OLLAMA_CHAT_MODEL",
      "provider": "ollama",
      "model": "$OLLAMA_CHAT_MODEL"
    }
  ],
  "contextProviders": [
    {
      "name": "code",
      "params": {}
    },
    {
      "name": "docs",
      "params": {}
    },
    {
      "name": "diff",
      "params": {}
    },
    {
      "name": "terminal",
      "params": {}
    },
    {
      "name": "problems",
      "params": {}
    },
    {
      "name": "folder",
      "params": {}
    },
    {
      "name": "codebase",
      "params": {}
    }
  ],
  "slashCommands": [
    {
      "name": "share",
      "description": "Export the current chat session to markdown"
    },
    {
      "name": "cmd",
      "description": "Generate a shell command"
    },
    {
      "name": "commit",
      "description": "Generate a git commit message"
    }
  ],
  "data": [],
  "tabAutocompleteModel": {
    "title": "$OLLAMA_CODE_MODEL",
    "provider": "ollama",
    "model": "$OLLAMA_CODE_MODEL"
  },
  "embeddingsProvider": {
    "provider": "ollama",
    "model": "$OLLAMA_EMBED_MODEL"
  }
}
EOF
