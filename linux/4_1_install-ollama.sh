#!/bin/bash

# Install Ollama in a persistent directory (see _wordslab-notebooks-env.bashrc)
mkdir -p $OLLAMA_DIR

# Download and uncompress the latest version of ollama
curl -L https://ollama.com/download/ollama-linux-amd64.tar.zst?version=0.15.1 -o ollama-linux-amd64.tar.zst
tar -C $OLLAMA_DIR -xf ollama-linux-amd64.tar.zst
rm ollama-linux-amd64.tar.zst

# Add ollama to the path so that anyone can control it on the machine
echo '' >> ./_wordslab-notebooks-env.bashrc
echo '# Add tools the PATH' >> ./_wordslab-notebooks-env.bashrc
echo 'export PATH="$OLLAMA_DIR/bin:$PATH"' >> ./_wordslab-notebooks-env.bashrc

# Need to set OLLAMA_HOME before downloading the language model
source ./_wordslab-notebooks-env.bashrc

# Download models for local inference
OLLAMA_HOME=0.0.0.0  $OLLAMA_DIR/bin/ollama serve &
pid=$!

# Wait for the server to be ready
while ! curl -s http://localhost:11434 > /dev/null; do
    sleep 1
done

# Choose a default local LLMs for this machine
if [ -f "$WORDSLAB_WORKSPACE/.cpu-only" ]; then
    OLLAMA_CHAT_MODEL="gemma3:1b"
    OLLAMA_CODE_MODEL="qwen3:1.7b"
    OLLAMA_AGENT_MODEL="lfm2.5-thinking:1.2b"
    OLLAMA_EMBED_MODEL="embeddinggemma:300m"
    OLLAMA_CONTEXT_LENGTH=8192
else
    # Get the GPU VRAM in MiB and choose the best chat model which fits in memory
    vram_gib=$(nvidia-smi --query-gpu=memory.total --format=csv,nounits,noheader | awk '{print int($1 / 1024)}')
    if [ "$vram_gib" -ge 31 ]; then        
        OLLAMA_CHAT_MODEL="gemma3:27b"
        OLLAMA_CODE_MODEL="qwen3-vl:30b"
        OLLAMA_AGENT_MODEL="devstral-small-2:24b"
        OLLAMA_EMBED_MODEL="embeddinggemma:300m"
        OLLAMA_CONTEXT_LENGTH=65536
        OLLAMA_AGENT_CONTEXT_LENGTH=98304
    elif [ "$vram_gib" -ge 23 ]; then        
        OLLAMA_CHAT_MODEL="gemma3:27b"
        OLLAMA_CODE_MODEL="qwen3-vl:30b"
        OLLAMA_AGENT_MODEL="glm-4.7-flash:q4_K_M"
        OLLAMA_EMBED_MODEL="embeddinggemma:300m"
        OLLAMA_CONTEXT_LENGTH=32768
        OLLAMA_AGENT_CONTEXT_LENGTH=49152
    elif [ "$vram_gib" -ge 15 ]; then
        OLLAMA_CHAT_MODEL="gemma3:12b"
        OLLAMA_CODE_MODEL="qwen3:14b"
        OLLAMA_AGENT_MODEL="gpt-oss:20b"
        OLLAMA_EMBED_MODEL="embeddinggemma:300m"
        OLLAMA_CONTEXT_LENGTH=32768
        OLLAMA_AGENT_CONTEXT_LENGTH=98304
    else
        OLLAMA_CHAT_MODEL="gemma3:4b"
        OLLAMA_CODE_MODEL="qwen3-vl:4b"
        OLLAMA_AGENT_MODEL="ministral-3:3b"
        OLLAMA_EMBED_MODEL="embeddinggemma:300m"
        OLLAMA_CONTEXT_LENGTH=16384
        OLLAMA_AGENT_CONTEXT_LENGTH=24576
    fi
fi

# Save the LLM names as env variables 
echo '' >> ./_wordslab-notebooks-env.bashrc
echo '# Default ollama model' >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_CHAT_MODEL=$OLLAMA_CHAT_MODEL" >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_CODE_MODEL=$OLLAMA_CODE_MODEL" >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_AGENT_MODEL=$OLLAMA_AGENT_MODEL" >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_EMBED_MODEL=$OLLAMA_EMBED_MODEL" >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_CONTEXT_LENGTH=$OLLAMA_CONTEXT_LENGTH" >> ./_wordslab-notebooks-env.bashrc

# Download the default local LLMs
$OLLAMA_DIR/bin/ollama pull $OLLAMA_CHAT_MODEL
$OLLAMA_DIR/bin/ollama pull $OLLAMA_CODE_MODEL
$OLLAMA_DIR/bin/ollama pull $OLLAMA_AGENT_MODEL
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
    "api_keys": {}
}
EOF

# Disable inline completion with Jupyter-ai: it is an "experimental" feature in Jupyterlab 4.1
# - doesn't work well, context is too small (one cell), implementation too naive
# - completions are triggered continuously, pushed the GPU to 100% all the time

#JIC_CONFIG_FILE="$JUPYTERLAB_SETTINGS_DIR/@jupyterlab/completer-extension/inline-completer.jupyterlab-settings"
#mkdir -p "$(dirname "$JIC_CONFIG_FILE")"
#cat > "$JIC_CONFIG_FILE" <<EOF
#EOF