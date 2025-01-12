#!/bin/bash

python -m venv --system-site-packages --prompt wordslab-notebooks-dashboard .venv
source .venv/bin/activate

pip install python-fasthtml==0.12.0