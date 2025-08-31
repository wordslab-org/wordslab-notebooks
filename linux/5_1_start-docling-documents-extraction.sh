#!/bin/bash

# Optional parameter: port to run Docling and its UI
# - default port 5001 for internal use from Open WebUI or JupyterLab
# - use one of the five $USER_APPx_PORT ports if you want Docling to be accessible from the outside world

# Start Docling server 
source $DOCLING_ENV/.venv/bin/activate
DOCLING_SERVE_ARTIFACTS_PATH=$DOCLING_MODELS DOCLING_SERVE_SCRATCH_PATH=$DOCLING_DATA DOCLING_SERVE_ENABLE_UI=true UVICORN_PORT=${1:-5001} docling-serve run &
exit $!