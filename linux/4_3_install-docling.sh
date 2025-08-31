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

# Initialize the Docling installation

source .venv/bin/activate

MODELS_LIST="layout tableformer picture_classifier easyocr"
docling-tools models download -o "$DOCLING_MODELS" $MODELS_LIST