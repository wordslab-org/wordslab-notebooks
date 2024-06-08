eval "$('/root/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
conda activate pytorch

jupyter lab -ServerApp.base_url="/" -ServerApp.port=8888 -IdentityProvider.token="" --no-browser -ServerApp.allow_root=True -ServerApp.allow_remote_access=True -ServerApp.root_dir="/workspace"
