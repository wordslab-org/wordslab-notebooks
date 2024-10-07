eval "$('/root/miniforge3/condabin/conda' 'shell.bash' 'hook' 2> /dev/null)"
conda activate pytorch-2.4

if ! pgrep -x "dockerd" > /dev/null; then
    echo "Docker is not running. Starting Docker service..."
    service docker start
fi

jupyter lab -ServerApp.base_url="/" -ServerApp.ip=0.0.0.0 -ServerApp.port=8888 -IdentityProvider.token="" --no-browser -ServerApp.allow_root=True -ServerApp.allow_remote_access=True -ServerApp.root_dir="/workspace"
