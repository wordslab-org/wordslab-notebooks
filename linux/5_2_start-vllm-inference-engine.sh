#!/bin/bash

# All parameters are forwarded as is to vllm serve

# Start vLLM server 
source $VLLM_ENV/.venv/bin/activate

vllm serve "$@"

# (APIServer pid=3074812) INFO:     Started server process [3074812]
# (APIServer pid=3074812) INFO:     Waiting for application startup.
# (APIServer pid=3074812) INFO:     Application startup complete.