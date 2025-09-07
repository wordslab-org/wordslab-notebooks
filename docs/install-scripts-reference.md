# Installation scripts documentation

Version: wordslab-notebooks **2025-09**

## Windows installation script details

The installation script will execute the following steps in order:

[windows/1_install-or-update-windows-subsystem-for-linux](https://github.com/wordslab-org/wordslab-notebooks/blob/main/install/windows/1_install-or-update-windows-subsystem-for-linux.ps1) 

Checks if the Windows Subsystem for Linux is already installed on your machine:
- if WSL is already installed: it will just try to update it to the latest version and move on
- if WSL needs to be installed: it will install WSL, then **you will have to reboot** your machine to finish the installation
- after reboot, you will need to reopen a Terminal and navigate to the wordslab-notebooks install directory (for example: *cd C:\\wordslab\\wordslab-notebooks*), then execute *install-wordslab-notebooks.bat* **a second time**

[windows/2_create-linux-virtual-machine](https://github.com/wordslab-org/wordslab-notebooks/blob/main/install/windows/2_create-linux-virtual-machine.bat)

Creates a Windows Subsystem for Linux virtual machine named **'wordslab-notebooks'** 
- minimal image of the Ubuntu Linux 24.04 distribution

## Linux installation script details

[linux/0_install-ubuntu-packages](https://github.com/wordslab-org/wordslab-notebooks/blob/main/install/linux/0_install-ubuntu-packages.sh)

Installs basic Linux packages and configures the Linux virtual machine
- sudo locales ca-certificates
- iputils-ping net-tools traceroute openssh-client
- curl wget unzip
- less vim tmux screen
- **git git-lfs**
- htop nvtop
- build-essential cmake
- ffmpeg
- **docker-ce** docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

[linux/1_install-python-envmanager](https://github.com/wordslab-org/wordslab-notebooks/blob/main/install/linux/1_install-python-envmanager.sh)

Installs a minimal Python environment manager
- Miniforge 3

[2_install-pytorch-cuda](https://github.com/wordslab-org/wordslab-notebooks/blob/main/install/linux/2_install-pytorch-cuda.sh)

Creates a new conda environment named **'pytorch-2.4'**. 

Installs the following Python packages and system librairies:
- python 3.12.7
- **cuda 12.4.0**
- **pytorch 2.4.0**, torchvision 0.19.0, torchaudio 2.4.0
- pandas 2.2.3, scikit-learn 1.5.2

Creates a **/models directory** inside the virtual machine where all datasets, models code and weights will be downloaded.

Sets the following environment variables to achieve this goal:
- HF_HOME=/models/huggingface
- FASTAI_HOME=/models/fastai
- TORCH_HOME=/models/torch
- KERAS_HOME=/models/keras
- TFHUB_CACHE_DIR=/models/tfhub_modules

The 'pytorch-2.4' conda environment is automatically activated when you log in to the virtual machine.

[3_install_jupyterlab_workspace](https://github.com/wordslab-org/wordslab-notebooks/blob/main/install/linux/3_install_jupyterlab_workspace.sh)

Installs the Jupyterlab notebooks environment with the following plugins
- jupyterlab 4.2.5 - notebooks development environment
- jupyterlab_execute_time 3.2.0 - execution time of each cell
- jupyterlab-nvdashboard 0.11.00 - graphs to monitor cpu, gpu and memory load
- jupyterlab-git 0.50.1 - visual git UI to version your notebooks and files

Creates a **/workspace directory** inside the virtual machine where all Jupyterlab config, notebooks and project directories will be stored.

Sets the following environment variables to achieve this goal:
- JUPYTER_CONFIG_DIR=/workspace/.jupyter/etc/jupyter
- JUPYTER_DATA_DIR=/workspace/.jupyter/share/jupyter
- JUPYTER_RUNTIME_DIR=/workspace/.jupyter/share/jupyter/runtime
- JUPYTERLAB_SETTINGS_DIR=/workspace/.jupyter/lab/user-settings
- JUPYTERLAB_WORKSPACES_DIR=/workspace/.jupyter/lab/workspaces

When you log in to the virtual machine, the terminal is automatically positionned in the /workspace directory.

Installs two scripts to help you initialize or delete workspace projects inside Jupyterlab
- [/usr/local/bin/create-workspace-project](https://github.com/wordslab-org/wordslab-notebooks/blob/main/install/linux/create-workspace-project)
- [/usr/local/bin/delete-workspace-project](https://github.com/wordslab-org/wordslab-notebooks/blob/main/install/linux/delete-workspace-project)

The usage of these scripts will be described below in more details when we explain the lifecycle of a workspace project.

Creates a first workspace project in /workspace/wordslab-notebooks-tutorials with **the wordslab-notebooks tutorials** found at https://github.com/wordslab-org/wordslab-notebooks-tutorials.