# wordslab-notebooks

**wordslab-notebooks** is a **one click installer** which will set up a GPU-accelerated workspace on your local PC to develop and test AI applications.

What you need
- a computer with a **x64 processor** (Intel or AMD) and at least 8 GB of RAM
- a disk with at least 20 GB space free (50 GB recommended)
- a **Nvidia GPU** if you want to train and use powerful AI models (RTX 3060 or higher recommended)
- Windows 10 or 11 (up to date with the latest updates) or Ubuntu Linux 22.04 or 24.04
- Windows only: administrator privileges to install the Windows Subsystem for Linux on your machine if it is not already available

What you will get
- a fully featured AI development environment based on **Jupyterlab notebooks** with popular tools and extensions
- a consistent installation of all the GPU-accelerated Python libraries you need to start your projects right away (see list below)
- scripts and tutorials to guide you through the whole development lifecycle (with Github and Huggingface)
- all that contained in a single "wordslab-notebooks" directory on your machine

Don't be deceived by the apparent simplicity of this solution: simplicity is the main feature of the product! It is the result of **many iterations over 4 years** to converge to this lightweight and seamless experience. You will see over time that everything you try just works out of the box.

WARNING: this local AI development environment is meant to be used **at home, on a computer which is not accessible from the internet**
- ease of use was prioritized for a single user in a safe environment
- **no access control or security measures** are implemented

## Windows installation instructions

### 1. Choose the parent directory where you want to install wordslab-notebooks

If you choose the parent directory: *C:\\wordslab*

All files (wordslab-notebooks software, your data and later downloads) will be stored inside the directory: *C:\\wordslab\\**wordslab-notebooks***

Check that there is enough space on the disk: **20 GB minimum**, 50 GB recommended. If you plan to download 100 GB of librairies and data for your project, you will need 100 (project) + 20 (wordslab-notebooks) = 120 GB of disk space.

Make sure that the directory you choose is not automatically mirrored in the cloud by a tool like OneDrive or DropBox. The wordslab-notebooks virtual machine disk is stored as a single file: it changes constantly and can get very large.

### 2. Open a Windows Terminal and navigate to the parent directory
   
If the Windows Subsystem for Linux is already installed on your machine: press the [Win + x] keys to open the Quick link menu, then the [i] key to open a Terminal without elevated privileges.

If the Windows Subsystem for Linux is NOT yet installed on your machine, or if you don't know what that means: press the [Win + x] keys to open the Quick link menu, then the [a] key to open a Terminal as Administrator, and click Yes to allow the Terminal to make changes on your computer.

Create the parent directory if it doesn't already exist: *mkdir c:\\wordslab\\*

Navigate to the parent directory: *cd c:\\wordslab\\*

### 3. Download wordslab-notebooks scripts

Copy and paste the commands below in the Terminal to download wordslab-notebooks scripts on your machine:

Click on the copy icon on the top right of the code section below.

Click on the Terminal, press [Ctrl + v], and then don't forget to press [Enter] to execute the last line.

```
curl -L -o wordslab-notebooks.zip https://github.com/wordslab-org/wordslab-notebooks/archive/refs/heads/main.zip
tar -x -f wordslab-notebooks.zip
del wordslab-notebooks.zip
ren wordslab-notebooks-main wordslab-notebooks
cd wordslab-notebooks
```

###  4. Install wordslab-notebooks virtual machine

Copy and paste the command below in the same Terminal to install wordslabs-notebooks on your machine:

```
install-wordslab-notebooks.bat
```

Note: this procedure will download and unpack around 18 GB of software
- on a fast computer with a 300 MBits/sec internet connection, this operation takes **8 minutes**
- the disk size of the .\\wordslab-notebooks directory after install is **18.6 GB**

You can take advantage of the next 8 minutes of installation time to read a description of all the actions executed on your computer below :-).

WARNING: this local AI development environment is meant to be used **at home, on a computer which is not accessible from the internet**
- ease of use was prioritized for a single user in a safe environment
- **no access control or security measures** are implemented
- this virtual machine is not safe to use on a shared computer or in the cloud
- anybody can start the virtual machine without any authentication
- they have **root access** to the virtual machine and all its contents
- the tools inside the virtual machine also run as root and have full access to all your data

The installation script will execute the following steps in order:

[windows-linux/1_install-or-update-windows-subsystem-for-linux](https://github.com/wordslab-org/wordslab-notebooks/blob/main/install/windows-linux/1_install-or-update-windows-subsystem-for-linux.ps1) 

Checks if the Windows Subsystem for Linux is already installed on your machine:
- if WSL is already installed: it will just try to update it to the latest version and move on
- if WSL needs to be installed: the script will check that you opened the Terminal with administrator privileges, it will install WSL, then **you will have to reboot** your machine to finish the installation
- after reboot, you will need to reopen a Terminal (this time administrator privileges won't be necessary, so press [Win + x] then [i]) and navigate to the wordslab-notebooks install directory (for example: *cd C:\\wordslab\\wordslab-notebooks*), then execute *install-wordslab-notebooks.bat* **a second time**

[windows-linux/2_create-linux-virtual-machine](https://github.com/wordslab-org/wordslab-notebooks/blob/main/install/windows-linux/2_create-linux-virtual-machine.bat)

Creates a Windows Subsystem for Linux virtual machine named **'wordslab-notebooks'** 
- minimal image of the Ubuntu Linux 24.04 distribution

[linux/0_install-ubuntu-packages](https://github.com/wordslab-org/wordslab-notebooks/blob/main/install/linux/0_install-ubuntu-packages.sh)

Installs basic Linux packages and configures the virtual machine
- sudo locales ca-certificates
- iputils-ping net-tools traceroute openssh-client
- curl wget unzip
- less vim tmux screen
- **git git-lfs**
- htop nvtop
- build-essential cmake
- **docker-ce** docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

[linux/1_install-python-envmanager](https://github.com/wordslab-org/wordslab-notebooks/blob/main/install/linux/1_install-python-envmanager.sh)

Installs a minimal Python environment manager
- Miniconda 3

[2_install-pytorch-cuda](https://github.com/wordslab-org/wordslab-notebooks/blob/main/install/linux/2_install-pytorch-cuda.sh)

Creates a new conda environment named **'wordslab-notebooks'**. 

Installs the following Python packages and system librairies:
- python 3.12.3
- cuda 12.1.0
- **pytorch 2.3.1**, torchvision 0.18.1, torchaudio 2.3.1
- pandas 2.2.1, scikit-learn 1.4.2

Creates a **/models directory** inside the virtual machine where all datasets, models code and weights will be downloaded.

Sets the following environment variables to achieve this goal:
- HF_HOME=/models/huggingface
- FASTAI_HOME=/models/fastai
- TORCH_HOME=/models/torch
- KERAS_HOME=/models/keras
- TFHUB_CACHE_DIR=/models/tfhub_modules

The 'wordslab-notebooks' conda environment is automatically activated when you log in to the virtual machine.

[3_install_jupyterlab_workspace](https://github.com/wordslab-org/wordslab-notebooks/blob/main/install/linux/3_install_jupyterlab_workspace.sh)

Installs the Jupyterlab notebooks environment with the following plugins
- jupyterlab 4.2.1 - notebooks development environment
- jupyterlab_execute_time 3.1.2 - execution time of each cell
- jupyterlab-nvdashboard 0.11.00 - graphs to monitor cpu, gpu and memory load
- jupyterlab-git 0.50.0 - visual git UI to version your notebooks and files

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

### 5. Start Jupyterlab and test your environment

Each time you want to start your AI development environment after installation, you need to repeat the following steps:
- press the [Win + x] keys to open the Quick link menu, then the [i] key to open a Terminal
- navigate to the wordslab-notebooks directory, for example: *cd c:\\wordslab\\wordslab-notebooks*
- then copy and paste the command below

```
start-wordslab-notebooks.bat
```

The script [start-wordslab-notebooks](https://github.com/wordslab-org/wordslab-notebooks/blob/main/start-wordslab-notebooks.sh) launches a Jupyterlab environment
- on the port 8888 of your local machine (you can simply update this value in the script if you want to change the port number)
- without authentication and without acces restrictions for other machines on your local network 

**Leave the Terminal open** as long as you want to use Jupyterlab: you will see logs displayed on the screen as you work in Jupyterlab, this is normal, you can ignore them.

**Open your browser** and navigate to the following URL: [http:127.0.0.1:8888](http:127.0.0.1:8888).

You should see Jupyterlab with a file navigator on the left side of the screen.

Double-click on the /wordslab-notebooks-tutorials directory, then double-click on the file 00_discover_noteboooks.ipynb
- a notebook should be displayed in the center of the screen
- Read its contents and click on the links to learn how to use Jupyterlab

### 6. Stop Jupyterlab after your work session

When your work session with Jupyterlab is finished
- please **make sure that you have saved** all the opened files
- click on the Terminal from which you launched Jupyterlab and which should still be open
- press the following two keys to stop the server, then confirm by pressing the key [y]

```
[Ctrl + c]
```

All your work and the current configuration of your development environment will be saved until your next work session in the virtual machine disk file stored at the following location on your PC:

> c:\\wordslab\\wordslab-notebooks\\wsl-vm\\xxx.vhdx

You may want to **compress and backup this file regularly** (only when wordslab-notebooks is stopped) if the files in your workspace are important

```
powershell -command "Compress-Archive -Path 'c:\\wordslab\\wordslab-notebooks\\wsl-vm\\xxx.vhdx' -DestinationPath 'd:\\backup\\xxx-2024-06-15.vhdx'"
```

### 7. Read the tutorials

See https://github.com/wordslab-org/wordslab-notebooks-tutorials

### 8. Initialize your first project

1. Initialize a Github project.

2. Open a Terminal then execute the following command:

```
create-workspace-project https://github.com/your-org/your-repo.git
```

3. Navigate to the directory named 'your-repo', and open a notebook with the kernel named 'your-repo'.
