cd ..\linux
wsl -d wordslab-notebooks -- ./0_install-ubuntu-packages.sh
wsl -d wordslab-notebooks -- ./1_install-python-envmanager.sh
wsl -d wordslab-notebooks -- ./2_install-pytorch-cuda.sh
wsl -d wordslab-notebooks -- ./3_install-jupyterlab-workspace.sh
