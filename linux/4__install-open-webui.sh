#!/bin/bash

# Install ollama to run local Large Language models
./4_1_install-ollama.sh

# Install Open WebUI multi-model chat interface
./4_2_install-open-webui.sh

# Install Docling document extraction
./4_3_install-docling.sh

# OPTIONAL - Install vLLM inference engine (+ full CUDA toolkit)
# ./4_4_install-vllm.sh