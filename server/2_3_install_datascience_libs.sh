conda install -y pandas=2.2.3 scikit-learn=1.5.2

mkdir -p $MODELS_DIR

echo 'export HF_HOME=$MODELS_DIR/huggingface' >> ~/wordslab-notebooks-environment.sh
echo 'export FASTAI_HOME=$MODELS_DIR/fastai' >> ~/wordslab-notebooks-environment.sh
echo 'export TORCH_HOME=$MODELS_DIR/torch' >> ~/wordslab-notebooks-environment.sh
echo 'export KERAS_HOME=$MODELS_DIR/keras' >> ~/wordslab-notebooks-environment.sh
echo 'export TFHUB_CACHE_DIR=$MODELS_DIR/tfhub_modules' >> ~/wordslab-notebooks-environment.sh
echo 'export OLLAMA_MODELS=$MODELS_DIR/ollama' >> ~/wordslab-notebooks-environment.sh