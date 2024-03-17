eval "$('/root/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
conda activate $1

conda install -y -c conda-forge jupyterlab=4.1.5
conda install -y -c conda-forge jupyterlab_execute_time=3.1.2
conda install -y -c rapidsai-nightly -c conda-forge jupyterlab-nvdashboard=0.11.0a0
conda install -y -c conda-forge jupyterlab-git=0.50.0
conda install -y -c conda-forge ipympl=0.9.3

mkdir -p /workspace

conda env config vars set JUPYTERLAB_SETTINGS_DIR=/workspace/.jupyter/lab/user-settings
conda env config vars set JUPYTERLAB_WORKSPACES_DIR=/workspace/.jupyter/lab/workspaces

cp ./create_workspace_project /usr/local/bin/create-workspace-project
chmod u+x /usr/local/bin/create-workspace-project
cp ./delete_workspace_project /usr/local/bin/delete-workspace-project
chmod u+x /usr/local/bin/delete-workspace-project
