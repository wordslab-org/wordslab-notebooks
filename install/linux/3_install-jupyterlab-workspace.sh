eval "$('/root/miniforge3/condabin/conda' 'shell.bash' 'hook' 2> /dev/null)"
conda activate pytorch-2.4

conda install -y jupyterlab=4.2.5
conda install -y jupyterlab_execute_time=3.2.0
conda install -y jupyterlab-nvdashboard=0.11.00
conda install -y jupyterlab-git=0.50.1
conda install -y ipympl=0.9.4

mkdir -p /workspace

conda env config vars set JUPYTER_CONFIG_DIR=/workspace/.jupyter/etc/jupyter
conda env config vars set JUPYTER_DATA_DIR=/workspace/.jupyter/share/jupyter
conda env config vars set JUPYTER_RUNTIME_DIR=/workspace/.jupyter/share/jupyter/runtime
conda env config vars set JUPYTERLAB_SETTINGS_DIR=/workspace/.jupyter/lab/user-settings
conda env config vars set JUPYTERLAB_WORKSPACES_DIR=/workspace/.jupyter/lab/workspaces
conda deactivate
conda activate pytorch-2.4

cp ./create-workspace-project /usr/local/bin/create-workspace-project
chmod u+x /usr/local/bin/create-workspace-project
cp ./delete-workspace-project /usr/local/bin/delete-workspace-project
chmod u+x /usr/local/bin/delete-workspace-project

echo 'cd /workspace' >> ~/.bashrc

create-workspace-project https://github.com/wordslab-org/wordslab-notebooks-tutorials.git
