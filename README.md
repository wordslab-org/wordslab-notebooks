# wordslab-notebooks

The simplest way to set up a GPU-accelerated workspace on your local PC to develop and test AI applications.

What you need
- a computer with a x64 processor (Intel or AMD) and at least 8 GB of RAM
- a disk with at least 20 GB space free (50 GB recommended)
- a Nvidia GPU if you want to train and use powerful deep learning models (RTX 3060 or higher recommended)
- Windows 10 or 11 (up to date with the latest updates) or Ubuntu Linux 22.04 or 24.04
- Windows only: administrator privileges to install the Windows Subsystem for Linux on your machine if it is not already available

What you will get
- a fully featured AI development environment based on Jupyterlab notebooks and popular tools and extensions
- a consistent installation of all the GPU-accelerated libraries you need to start your projects right away (see list below)
- scripts and tutorials to guide you through the whole development lifecycle (with Github and Huggingface)
- all that with a one click install contained in a single directory on your machine

## Windows installation instructions

### 1. Choose the parent directory where you want to install wordslab-notebooks

For example if you choose the parent directory: C:\\wordslab, all files (software, your data, later downloads) will be stored inside: C:\\wordslab\\**wordslab-notebooks**.

Check that there is enough space on the disk: **20 GB minimum**, 50 GB recommended. If you plan to download 100 GB of software and data for your project, you will need 100 (project) + 20 (wordslab-notebooks) = 120 GB of disk space.

Make sure that the directory you choose is not automatically mirrored in the cloud by a tool like OneDrive or DropBox. The virtual machine disk is represented by a single file which gets very large and changes constantly.

#### 2. Open a Windows Terminal and navigate to the parent directory
   
If the Windows Subsystem for Linux is already installed on your machine: press the [Win + x] keys to open the Quick link menu, then the [i] key to open a Terminal without elevated privileges.

If the Windows Subsystem for Linux is NOT yet installed on your machine, or if you don't know what that means: press the [Win + x] keys to open the Quick link menu, then the [a] key to open a Terminal as Administrator, and click Yes to allow the Terminal to make changes on your computer.

Create the parent directory if it doesn't already exist: *mkdir c:\\wordslab\\*

Navigate to the parent directory: *cd c:\\wordslab\\*

#### 3. Download wordslab-notebooks scripts

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

The installation script will execute the following steps in order:

[windows-linux/1_install-or-update-windows-subsystem-for-linux](https://github.com/wordslab-org/wordslab-notebooks/blob/main/install/windows-linux/1_install-or-update-windows-subsystem-for-linux.ps1) 

Checks if the Windows Subsystem for Linux is already installed on your machine:
- if WSL is already installed: it will just try to update it to the latest version and move on
- if WSL needs to be installed: the script will check that you opened the Terminal with administrator privileges, it will install WSL, then **you will have to reboot** to finish the installation
- after reboot, you will need to reopen a Terminal (this time administrator privileges won't be necessary, so [Win + x] then [i]), to navigate to the wordslab-notebooks install directory (for example: *cd C:\\wordslab\\wordslab-notebooks*), and to execute *install-wordslab-notebooks.bat* a second time

[windows-linux/2_create-linux-virtual-machine](https://github.com/wordslab-org/wordslab-notebooks/blob/main/install/windows-linux/2_create-linux-virtual-machine.bat)

Creates a Windows Subsystem for Linux virtual machine named 'wordslab-notebook' 
- based on a minimal image of the Ubuntu Linux 24.04 distribution

[linux/0_install-ubuntu-packages](https://github.com/wordslab-org/wordslab-notebooks/blob/main/install/linux/0_install-ubuntu-packages.sh)

Installs basic Linux packages and configures the virtual machine
- sudo locales ca-certificates
- curl wget unzip
- less vim tmux screen
- git git-lfs
- htop nvtop
- iputils-ping net-tools traceroute openssh-client
- build-essential cmake
- docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

[linux/1_install-python-envmanager](https://github.com/wordslab-org/wordslab-notebooks/blob/main/install/linux/1_install-python-envmanager.sh)

Installs a minimal Python environment manager
- Miniconda 3




### 3- Start Jupyterlab and test your environment

Open a Command Prompt:

```
set installdir=%HOMEPATH%

cd %installdir%\wordslab-notebooks
start-wordslab-notebooks.bat

```

Open your browser to navigate to the following URL: [http:127.0.0.1:8888](http:127.0.0.1:8888).

### 4- Initialize your first project

1. Initialize a Github project.

2. Open a Terminal then execute the following command:

```
create-workspace-project https://github.com/your-org/your-repo.git
```

3. Navigate to the directory named 'your-repo', and open a notebook with the kernel named 'your-repo'.
