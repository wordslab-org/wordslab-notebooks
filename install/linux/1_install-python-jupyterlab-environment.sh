echo Downloading installer...
cd ~
curl -LO --no-progress-meter https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

bash Miniconda3-*.sh -b
~/miniconda3/bin/conda init $SHELL

rm Miniconda3-latest-Linux-x86_64.sh

source .bashrc

conda install -y -c conda-forge jupyterlab= 4.1.5
conda install -y -c conda-forge jupyterlab_execute_time= 3.1.2
conda install -y -c rapidsai-nightly -c conda-forge jupyterlab-nvdashboard= 0.11.0a0
conda install -y -c conda-forge jupyterlab-git=0.50.0
conda install -y -c conda-forge ipympl= 0.9.3

mkdir -p /workspace

conda env config vars set JUPYTERLAB_SETTINGS_DIR=/workspace/.jupyter/lab/user-settings
conda env config vars set JUPYTERLAB_WORKSPACES_DIR=/workspace/.jupyter/lab/workspaces