eval "$('/root/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"

conda create -y --name wordslab-notebooks python==3.11.9 ninja=1.10.2
conda activate wordslab-notebooks

conda install -y cuda -c nvidia/label/cuda-12.4.0
conda install -y pytorch=2.4.0 torchvision=0.19.0 torchaudio=2.4.0 pytorch-cuda=12.4 -c pytorch -c nvidia/label/cuda-12.4.0
conda install -y pandas=2.2.1 scikit-learn=1.4.2

mkdir -p /models

conda env config vars set HF_HOME=/models/huggingface
conda env config vars set FASTAI_HOME=/models/fastai
conda env config vars set TORCH_HOME=/models/torch
conda env config vars set KERAS_HOME=/models/keras
conda env config vars set TFHUB_CACHE_DIR=/models/tfhub_modules

echo 'conda activate wordslab-notebooks' >> ~/.bashrc
