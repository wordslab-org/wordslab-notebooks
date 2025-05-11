#!/bin/bash
cpu_only=$1

# Register that the install is CPU only
if [ "$cpu_only" == "true" ]; then
    touch $WORDSLAB_WORKSPACE/.cpu-only
fi

# The most important responsability of this script:
# Configure all popular deeplearning librairies to download models and datasets under the $WORDSLAB_MODEL directory (see _wordslab-notebooks-env.bashrc) 

mkdir -p $WORDSLAB_MODELS

if [ ! -f ~/.wordslab-installed ]; then

    echo '' >> ./_wordslab-notebooks-env.bashrc
    echo '# Models and datasets download directories' >> ./_wordslab-notebooks-env.bashrc
    echo 'export HF_HOME=$WORDSLAB_MODELS/huggingface' >> ./_wordslab-notebooks-env.bashrc
    echo 'export FASTAI_HOME=$WORDSLAB_MODELS/fastai' >> ./_wordslab-notebooks-env.bashrc
    echo 'export TORCH_HOME=$WORDSLAB_MODELS/torch' >> ./_wordslab-notebooks-env.bashrc
    echo 'export KERAS_HOME=$WORDSLAB_MODELS/keras' >> ./_wordslab-notebooks-env.bashrc
    echo 'export TFHUB_CACHE_DIR=$WORDSLAB_MODELS/tfhub_modules' >> ./_wordslab-notebooks-env.bashrc
    echo 'export OLLAMA_MODELS=$WORDSLAB_MODELS/ollama' >> ./_wordslab-notebooks-env.bashrc
fi

if [ ! -d $WORDSLAB_WORKSPACE/wordslab-notebooks-tutorials ]; then

    # Create a first workspace project with tutorials for wordslab notebooks
    create-workspace-project https://github.com/wordslab-org/wordslab-notebooks-tutorials.git
else

    # Update the workspace project with tutorials for wordslab notebooks
    git -C $WORDSLAB_WORKSPACE/wordslab-notebooks-tutorials pull
fi

# => create-workspace-project will copy the ../projects/pyproject.toml file in this workspace project
# => then it will install all the common datascience librairies, Pytorch (GPU or CPU version), and VLLM (GPU version)