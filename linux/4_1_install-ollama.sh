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
# 11    Qwen3.5 0.8B
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
# 16    Qwen3.5 0.8B
# 11    Ministral 3 3B
# 7     Gemma 4 E2B
# 7     Gemma 4 E4B
# 7     LFM2.5-1.2B-Thinking

# Choose a default local LLMs for this machine
if [ -f "$WORDSLAB_WORKSPACE/.cpu-only" ]; then
    OLLAMA_CHAT_MODEL="gemma3:1b"
    OLLAMA_CHAT_CONTEXT=32
    OLLAMA_FAST_MODEL="lfm2.5-thinking:1.2b"
    OLLAMA_FAST_CONTEXT=128
    OLLAMA_AGENT_MODEL="qwen3.5:0.8b"
    OLLAMA_AGENT_CONTEXT=120 # 104 fp16
else
    # Get the GPU VRAM in MiB and choose the best local models which fit in memory
    # Warning: all token generation speeds measured with ollama 0.10.4 on a RTX 5090, comparison at mid context length
    vram_gib=$(nvidia-smi --query-gpu=memory.total --format=csv,nounits,noheader | awk '{print int($1 / 1024)}')
    if [ "$vram_gib" -ge 31 ]; then        
        OLLAMA_CHAT_MODEL="gemma4:31b" # 60-47-39 t/s q8 | 60-52-48 fp16 (+10%)
        OLLAMA_CHAT_CONTEXT=136 # 72 fp16 (-47%)
        OLLAMA_FAST_MODEL="qwen3.6:35b" # 130-120-103 t/s q8 | 143-123-109 fp16 (+3%)
        OLLAMA_FAST_CONTEXT=160 # 128 fp16 (-20%)
        OLLAMA_AGENT_MODEL="qwen3.6:27b" # 61-54-47 t/s q8 | 60-51-35 fp16 (-6%)
        OLLAMA_AGENT_CONTEXT=136 # 92 fp16 (-32%)
    elif [ "$vram_gib" -ge 23 ]; then        
        OLLAMA_CHAT_MODEL="gemma4:26b" # 166-94-65 t/s q8 | 166-124-103 fp16 (+32%)
        OLLAMA_CHAT_CONTEXT=176 # 124 fp16 (-30%)
        OLLAMA_FAST_MODEL="glm-4.7-flash:q4_K_M" # 139-70-42 t/s q8 | 148-96-71 fp16 (+37%)
        OLLAMA_FAST_CONTEXT=50 # 32 fp16 (-36%)
        OLLAMA_AGENT_MODEL="qwen3.5:9b" # 152-118-94 t/s q8 | 152-111-84 fp16 (-6%)
        OLLAMA_AGENT_CONTEXT=256
    elif [ "$vram_gib" -ge 15 ]; then
        OLLAMA_CHAT_MODEL="gemma4:e4b" # 180-120-86 t/s q8 | 189-148-128 fp16 (+23%)
        OLLAMA_CHAT_CONTEXT=128
        OLLAMA_FAST_MODEL="gpt-oss:20b" # 235-162-121 q8 | 238-189-157 fp16 (+16%) 
        OLLAMA_FAST_CONTEXT=64 # 44 fp16 (-43%)
        OLLAMA_AGENT_MODEL="qwen3.5:9b" # 152-118-94 t/s q8 | 152-111-84 fp16 (-6%)
        OLLAMA_AGENT_CONTEXT=176 # 136 fp16 (-22%)
    else
        OLLAMA_CHAT_MODEL="gemma3:4b" # 246-220-200 t/s q8 | 248-208-175 t/s fp16 (-6%)
        OLLAMA_CHAT_CONTEXT=120 # 100 fp16 (-16%)
        OLLAMA_FAST_MODEL="ministral-3:3b" # 326-125-70 t/s q8 | 338-120-68 fp16 (-4%)
        OLLAMA_FAST_CONTEXT=32 # 20 fp16 (-37%)
        OLLAMA_AGENT_MODEL="qwen3.5:2b" # 276-227-186 t/s q8 | 280-213-177 fp16 (-6%)
        OLLAMA_AGENT_CONTEXT=112 # 100 fp16 (-10%) 
    fi
fi
OLLAMA_EMBED_MODEL="embeddinggemma:300m"
OLLAMA_OCR_MODEL="glm-ocr:q8_0"

# Download the default local LLMs
pairs=(
  "$OLLAMA_CHAT_MODEL#$OLLAMA_CHAT_CONTEXT"
  "$OLLAMA_FAST_MODEL#$OLLAMA_FAST_CONTEXT"
  "$OLLAMA_AGENT_MODEL#$OLLAMA_AGENT_CONTEXT"
)
for pair in "${pairs[@]}"; do
  IFS="#" read -r OLLAMA_MODEL OLLAMA_CONTEXT <<< "$pair"
  NEW_MODEL="${OLLAMA_MODEL}-${OLLAMA_CONTEXT}k"
  CONTEXT_TOKENS=$((OLLAMA_CONTEXT * 1024))

  ollama pull "${OLLAMA_MODEL}"

  MODELFILE=$(mktemp)
  cat > "${MODELFILE}" <<EOF
FROM ${OLLAMA_MODEL}
PARAMETER num_ctx ${CONTEXT_TOKENS}
EOF
  ollama create "${NEW_MODEL}" -f "${MODELFILE}"
  rm -f "${MODELFILE}"
done

$OLLAMA_DIR/bin/ollama pull $OLLAMA_EMBED_MODEL
$OLLAMA_DIR/bin/ollama pull $OLLAMA_OCR_MODEL

# Save the LLM names as env variables 
echo '' >> ./_wordslab-notebooks-env.bashrc
echo '# Default ollama model' >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_CHAT_MODEL=${OLLAMA_CHAT_MODEL}-$((OLLAMA_CHAT_CONTEXT * 1024))k" >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_FAST_MODEL=${OLLAMA_FAST_MODEL}-$((OLLAMA_FAST_CONTEXT * 1024))k" >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_AGENT_MODEL=${OLLAMA_AGENT_MODEL}-$((OLLAMA_AGENT_CONTEXT * 1024))k" >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_EMBED_MODEL=$OLLAMA_EMBED_MODEL" >> ./_wordslab-notebooks-env.bashrc
echo "export OLLAMA_OCR_MODEL=$OLLAMA_EMBED_MODEL" >> ./_wordslab-notebooks-env.bashrc

# Stop ollama
kill $pid