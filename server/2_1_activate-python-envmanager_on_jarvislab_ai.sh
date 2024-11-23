eval "$('/root/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
conda_envs=$(conda env list)
torch_env=$(echo "$conda_envs" | awk 'NR==4 {print $1}')
conda activate $torch_env
