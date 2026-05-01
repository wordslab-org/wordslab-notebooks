#!/bin/bash

# Install Ollama in a persistent directory (see _wordslab-notebooks-env.bashrc)
mkdir -p $OLLAMA_DIR

# Download and uncompress the latest version of ollama
curl -L https://ollama.com/download/ollama-linux-amd64.tar.zst?version=0.22.1 -o ollama-linux-amd64.tar.zst
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

# Text Arena leaderboard
# 1451    Gemma 4 31B
# 1438    Gemma 4 26B A4B
# 1405    Qwen3.5 27B
# 1396    Qwen3.5 35B A3B
# 1368    GLM-4.7-Flash
# 1317    gpt-oss-20B (high)

# Artificial Analysis Intelligence Index
# 46    Qwen3.6 27B
# 43    Qwen3.6 35B A3B
# 39    Gemma 4 31B
# 32    Qwen3.5 9B
# 31    Gemma 4 26B A4B
# 30    GLM-4.7-Flash
# 27    Qwen3.5 4B
# 24    gpt-oss-20B (high)
# 19    Gemma 4 E4B
# 16    Qwen3.5 2B
# 15    Gemma 4 E2B
# 11    Ministral 3 3B
# 8     LFM2.5-1.2B-Thinking

# Artificial Analysis Agentic Index
# 63    Qwen3.6 27B
# 58    Qwen3.6 35B A3B
# 46    GLM-4.7-Flash
# 41    Gemma 4 31B
# 37    Qwen3.5 9B
# 32    Qwen3.5 4B
# 32    Gemma 4 26B A4B
# 28    gpt-oss-20B (high)
# 23    Qwen3.5 2B
# 11    Ministral 3 3B
# 7     Gemma 4 E2B
# 7     Gemma 4 E4B
# 7     LFM2.5-1.2B-Thinking

# Choose a default local LLMs for this machine
if [ -f "$WORDSLAB_WORKSPACE/.cpu-only" ]; then
    OLLAMA_CHAT_MODEL="gemma4:e2b"
    OLLAMA_FAST_MODEL="lfm2.5-thinking:1.2b"
    OLLAMA_AGENT_MODEL="qwen3.5:2b"
    OLLAMA_CONTEXT_LENGTH=8192
    OLLAMA_AGENT_CONTEXT_LENGTH=16384
else
    # Get the GPU VRAM in MiB and choose the best chat model which fits in memory
    vram_gib=$(nvidia-smi --query-gpu=memory.total --format=csv,nounits,noheader | awk '{print int($1 / 1024)}')
    if [ "$vram_gib" -ge 31 ]; then        
        OLLAMA_CHAT_MODEL="gemma4:31b"
        OLLAMA_FAST_MODEL="qwen3.6:35b"
        OLLAMA_AGENT_MODEL="qwen3.6:27b"
        OLLAMA_CONTEXT_LENGTH=65536
        OLLAMA_AGENT_CONTEXT_LENGTH=98304
    elif [ "$vram_gib" -ge 23 ]; then        
        OLLAMA_CHAT_MODEL="gemma4:26b"
        OLLAMA_FAST_MODEL="glm-4.7-flash:q4_K_M"
        OLLAMA_AGENT_MODEL="qwen3.6:27b"
        OLLAMA_CONTEXT_LENGTH=32768
        OLLAMA_AGENT_CONTEXT_LENGTH=49152
    elif [ "$vram_gib" -ge 15 ]; then
        OLLAMA_CHAT_MODEL="gemma4:e4b"
        OLLAMA_FAST_MODEL="gpt-oss:20b"
        OLLAMA_AGENT_MODEL="qwen3.5:9b"
        OLLAMA_CONTEXT_LENGTH=32768
        OLLAMA_AGENT_CONTEXT_LENGTH=98304
    else
        OLLAMA_CHAT_MODEL="gemma4:e2b"
        OLLAMA_FAST_MODEL="ministral-3:3b"
        OLLAMA_AGENT_MODEL="qwen3.5:4b"
        OLLAMA_CONTEXT_LENGTH=16384
        OLLAMA_AGENT_CONTEXT_LENGTH=24576
    fi
fi
OLLAMA_EMBED_MODEL="embeddinggemma:300m"
OLLAMA_OCR_MODEL="glm-ocr:q8_0"

# Save the LLM names as env variables 
echo '' >> ./_wordslab-notebooks-env.bashrc
echo '# Default ollama model' >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_CHAT_MODEL=$OLLAMA_CHAT_MODEL" >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_FAST_MODEL=$OLLAMA_FAST_MODEL" >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_AGENT_MODEL=$OLLAMA_AGENT_MODEL" >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_EMBED_MODEL=$OLLAMA_EMBED_MODEL" >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_OCR_MODEL=$OLLAMA_EMBED_MODEL" >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_CONTEXT_LENGTH=$OLLAMA_CONTEXT_LENGTH" >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_AGENT_CONTEXT_LENGTH=$OLLAMA_CONTEXT_LENGTH" >> ./_wordslab-notebooks-env.bashrc

# Download the default local LLMs
$OLLAMA_DIR/bin/ollama pull $OLLAMA_CHAT_MODEL
$OLLAMA_DIR/bin/ollama pull $OLLAMA_FAST_MODEL
$OLLAMA_DIR/bin/ollama pull $OLLAMA_AGENT_MODEL
$OLLAMA_DIR/bin/ollama pull $OLLAMA_EMBED_MODEL
$OLLAMA_DIR/bin/ollama pull $OLLAMA_OCR_MODEL

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