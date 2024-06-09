# wordslab-notebooks

Simple procedures and scripts to initialize a Jupyterlab workspace with GPU access for AI workloads

## Windows machine

### Download wordslab-notebooks scripts

1. Choose the parent directory where you want to install wordslab-notebooks on your Windows machine.

For example if you choose the parent directory: C:\\wordslab, all files (software, your data, later downloads) will be stored inside: C:\\wordslab\\**wordslab-notebooks**.

Check that there is enough space on the disk: **20 GB minimum**, 50 GB recommended. If you plan to download 100 GB of software and data for your project, you will need 100 (project) + 20 (wordslab-notebooks) = 120 GB of disk space.

Make sure that the directory you choose is not automatically mirrored in the cloud by a tool like OneDrive or DropBox. The virtual machine disk is represented by a single file which gets very large and changes constantly.

2. Open a Windows Terminal and navigate to the parent directory.
   
If the Windows Subsystem for Linux is already installed on your machine: press the [Win + x] keys to open the Quick link menu, then the [i] key to open a Terminal without elevated privileges.

If the Windows Subsystem for Linux is NOT yet installed on your machine, or if you don't know what that means: press the [Win + x] keys to open the Quick link menu, then the [a] key to open a Terminal as Administrator, and click Yes to allow the Terminal to make changes on your computer.

Create the parent directory if it doesn't already exist: *mkdir c:\\wordslab\\*

Navigate to the parent directory: *cd c:\\wordslab\\*

4. Copy and paste the commands below in the Terminal to download wordslab-notebooks scripts.

Click on the copy icon on the top right of the code section below.

Click on the Terminal, press [Ctrl + v], and then don't forget to press [Enter] to execute the last line.

```
curl -L -o wordslab-notebooks.zip https://github.com/wordslab-org/wordslab-notebooks/archive/refs/heads/main.zip
tar -x -f wordslab-notebooks.zip
del wordslab-notebooks.zip
ren wordslab-notebooks-main wordslab-notebooks
cd wordslab-notebooks
```

### Install wordslab-notebooks virtual machine

4. Copy and paste the command below in the same Terminal to install wordslabs-notebooks on your machine. 

```
install-wordslab-notebooks.bat
```

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



### 2- Create a linux virtual machine with Jupyterlab and Pytorch

Open a Command Prompt:

```
set installdir=%HOMEPATH%

cd %installdir%\wordslab-notebooks\install\windows-linux
2_create-linux-virtual-machine.bat

```

Note
- this operation will download and unpack around 18 GB of software
- on a fast computer with a 300 MBits/sec internet connection, this operation takes **8 minutes**
- the disk size of the %installdir%\wordslab-notebooks directory after install is **18.6 GB**

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
