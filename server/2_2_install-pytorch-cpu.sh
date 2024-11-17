eval "$('/root/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"

conda create -y --name pytorch-2.4 python==3.12.7 ninja=1.12.1
conda activate pytorch-2.4

conda install -y pytorch=2.4.0 torchvision=0.19.0 torchaudio=2.4.0 cpuonly -c pytorch

echo 'conda activate pytorch-2.4' >> ~/.bashrc
