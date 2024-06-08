eval "$('/root/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"

conda create -y --name pytorch python==3.12.3 ninja=1.10.2
conda activate pytorch

conda install -y cuda -c nvidia/label/cuda-12.1.0
conda install --force-reinstall -y libnvjitlink=12.1.105 libnvjitlink-dev=12.1.105 -c nvidia
conda install -y pytorch=2.3.1 torchvision=0.18.1 torchaudio=2.3.1 pytorch-cuda=12.1 -c pytorch -c nvidia/label/cuda-12.1.0
conda install -y pandas=2.2.1 scikit-learn=1.4.2

mkdir -p /models

conda env config vars set HF_HOME=/models/huggingface
conda env config vars set FASTAI_HOME=/models/fastai
conda env config vars set TORCH_HOME=/models/torch
conda env config vars set KERAS_HOME=/models/keras
conda env config vars set TFHUB_CACHE_DIR=/models/tfhub_modules

./3_install_jupyterlab_workspace.sh pytorch

echo 'conda activate pytorch' >> ~/.bashrc
