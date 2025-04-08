#!/bin/bash

# Only install very basic datascience librairies in the conda environment: pandas and scikit-learn
# All other librairies will be installed project by project in isolated virtual environments (see create-workspace-project)

pip install pandas==2.2.3 scikit-learn==1.6.1 
# Temporary: fastai 2.7.19 is not compatible with Pytorch 2.6 => waiting for fastai 2.8.1
pip install git+https://github.com/fastai/fastai.git

# The most important responsability of this script:
# Configure all popular deeplearning librairies to download models and datasets under the $WORDSLAB_MODEL directory (see _wordslab-notebooks-env.bashrc) 

mkdir -p $WORDSLAB_MODELS

echo '' >> ./_wordslab-notebooks-env.bashrc
echo '# Models and datasets download directories' >> ./_wordslab-notebooks-env.bashrc
echo 'export HF_HOME=$WORDSLAB_MODELS/huggingface' >> ./_wordslab-notebooks-env.bashrc
echo 'export FASTAI_HOME=$WORDSLAB_MODELS/fastai' >> ./_wordslab-notebooks-env.bashrc
echo 'export TORCH_HOME=$WORDSLAB_MODELS/torch' >> ./_wordslab-notebooks-env.bashrc
echo 'export KERAS_HOME=$WORDSLAB_MODELS/keras' >> ./_wordslab-notebooks-env.bashrc
echo 'export TFHUB_CACHE_DIR=$WORDSLAB_MODELS/tfhub_modules' >> ./_wordslab-notebooks-env.bashrc
echo 'export OLLAMA_MODELS=$WORDSLAB_MODELS/ollama' >> ./_wordslab-notebooks-env.bashrc
