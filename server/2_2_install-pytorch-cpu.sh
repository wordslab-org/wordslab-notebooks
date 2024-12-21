eval "$('/root/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"

conda create -y --name pytorch-2.5 python==3.12.8 ninja=1.12.1
conda activate pytorch-2.5

pip install torch=2.5.1 torchvision=0.20.1 torchaudio=2.5.1 --index-url https://download.pytorch.org/whl/cpu

echo 'conda activate pytorch-2.5' >> ~/.bashrc
