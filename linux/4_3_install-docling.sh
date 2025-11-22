#!/bin/bash

# Create the directory inside the workspace where all Docling documents will be stored
# and the directory where the Docling models will be stored

mkdir -p $DOCLING_DATA
mkdir -p $DOCLING_MODELS

# Create the Docling environment

mkdir -p $DOCLING_ENV
cp ./4_3_docling-pyproject.toml $DOCLING_ENV/pyproject.toml

# Download docling and docling-serve

cd $DOCLING_ENV
if [ -f "$WORDSLAB_WORKSPACE/.cpu-only" ]; then
    uv sync --extra cpu
else
    uv sync --extra cuda
fi

# After testing, granite-docling inference doesn't work with hf transformers as of 09/28 2025 - leaving this here for a future version
# Temporary patch: docling-serve 1.5.1 and Open WebUI 0.6.31 don't support the recent granite-docling VLM yet, while docling 2.54.0 already supports it
# => set this model as default in a VLM pipeline when no model is explicitly selected in the request params
# sed -i 's/pipeline_options\.vlm_options = vlm_model_specs\.SMOLDOCLING_TRANSFORMERS/pipeline_options\.vlm_options = vlm_model_specs\.GRANITEDOCLING_TRANSFORMERS/g' $DOCLING_ENV/.venv/lib/python3.12/site-packages/docling_jobkit/convert/manager.py

# Initialize the Docling installation

source .venv/bin/activate

# After testing, granite-docling inference doesn't work with hf transformers as of 09/28 2025 - leaving this here for a future version
# MODELS_LIST="layout tableformer code_formula picture_classifier easyocr granitedocling"

# Need this to set HF_HOME before the models download - for xet cache
source $WORDSLAB_SCRIPTS/linux/_wordslab-notebooks-env.bashrc

docling-tools models download -o "$DOCLING_MODELS"
docling-tools models download-hf-repo -o "$DOCLING_MODELS" ibm-granite/granite-docling-258M