eval "$('/root/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"

conda create -y --name wordslab-2024-12 python==3.12.8 ninja=1.12.1
conda activate wordslab-2024-12

pip install torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1

echo 'conda activate wordslab-2024-12' >> ~/.bashrc
