# Install wordslab on a Local PC

Choose 3 directories on your machine

WORDSLAB_HOME : wordslab installation scripts and virtual disk containing the Linux virtual machine OS and all applications installed by wordslab (initial size 20 GB) 
- default: c:\wordslab

WORDSLAB_WORKSPACE : virtual disk containing your projects code and data + their specific software dependencies (initial size 1 GB) 
- default: %WORDSLAB_HOME%\virtual-machines\wordslab-workspace

WORDSLAB_MODELS : virtual disk containing all the AI models initially installed by wordslab and then downloaded in the course of your projects (initial size 8 to 36 GB depending of your GPU VRAM) 
- default: %WORDSLAB_HOME%\virtual-machines\wordslab-models
		
If your machine has several physical disks or partitions, you can split your wordslab install between all of them to best use your available storage space.
	
Avoid choosing directories which are automatically synchronized with a remote storage service like OneDrive because the virtual disks files are huge and are continously updated.
	
Choose a disk with a fast reading speed for WORDSLAB_MODELS or you will have to wait several minutes each time you want load a 10+ GB model in memory.

The script wil automatically create the directories if they don't already exist.

If the Windows Subsystem for Linux is not yet installed on your machine
- the script will prompt you for administrator access
- then the script will ask you to reboot your machine once
- after reboot, relaunch the same command as above a second time to continue and finish the installation 

The installation scripts will download up to 50 GB: the install time will mainly depend on your network bandwidth.

Installation script parameters for special cases (you shouldn't need them)
- you can add the -cpu flag to the install command if you want to force a CPU-only install even if a Nvidia GPU is available on your machine 
- you can add the -name <virtual-machine-name> parameter if you want to install several versions of wordslab notebooks in parallel on the same machine: the workspace and models virtual disks will be shared between these versions (default virtual machine name: wordslab-notebooks)

## Windows installation instructions

### Windows install commands

1. Click on the Windows start icon

![Start menu](./images/install-local/01-start-menu.png)

2. Type the three letters "cmd", then click on "Run as administrator"

![cmd search](./images/install-local/02-cmd-search.png)

3. This will open the Command Prompt with administrator privileges

![Command prompt admin](./images/install-local/03-command-prompt-admin.png)

4. Copy / paste the installation command below in the terminal

```shell
set "WORDSLAB_WINDOWS_HOME=C:\wordslab" && call set "WORDSLAB_WINDOWS_WORKSPACE=%WORDSLAB_WINDOWS_HOME%\virtual-machines\wordslab-workspace"  && call set "WORDSLAB_WINDOWS_MODELS=%WORDSLAB_WINDOWS_HOME%\virtual-machines\wordslab-models" && call set "WORDSLAB_VERSION=2025-09" && call curl -sSL "https://raw.githubusercontent.com/wordslab-org/wordslab-notebooks/refs/tags/%WORDSLAB_VERSION%/install-wordslab-notebooks.bat" -o "%temp%\install-wordslab-notebooks.bat" && call "%temp%\install-wordslab-notebooks.bat"
```

![Installation command](./images/install-local/04-installation-command.png)

5. Personalize the installation paths on your computer, and select the version you want to install

- set "WORDSLAB_WINDOWS_HOME=C:\wordslab" 
- set "WORDSLAB_WINDOWS_WORKSPACE=%WORDSLAB_WINDOWS_HOME%\virtual-machines\wordslab-workspace" 
- set "WORDSLAB_WINDOWS_MODELS=%WORDSLAB_WINDOWS_HOME%\virtual-machines\wordslab-models"
- set WORDSLAB_VERSION=2025-09

Press Enter to launch the installation script

6. OPTION 1: The Windows Subsystem for Linux is already installed on your machine

![WSL already exists](./images/install-local/05-wsl-already-exists.png)

=> the script will jump directly to step 9.

6. OPTION 2: The Windows Subsystem for Linux is downloaded

![WSL download](./images/install-local/06-wsl-download.png)

7. The Windows Virtual Machine Platform is downloaded and installed

![WSL install](./images/install-local/07-wsl-install.png)

You may have to wait several minutes fot the downloads and installs to complete …

8. When prompted by the script, press "y" to reboot the machine.

![WSL reboot](./images/install-local/08-wsl-reboot.png)

The Windows updates will be applied during the reboot.

=> After the reboot, please restart the exact same install procedure at step 1

9. The wordlabs-notebooks virtual machine and virtual disks are created

![Create VMs](./images/install-local/09-vms-create.png)

=> The next installation steps will be executed automatically inside the Linux virtual machine without any user intervention

=> they are identical for a Windows or Linux install, see below

### wordslab-notebooks installation steps

1. Ubuntu packages and Docker (only if the script is not already running inside a docker container)

![Install Ubuntu](./images/install-local/10-ubuntu-install.png)

2. Python and uv package manager

![Install Python](./images/install-local/11-python-install.png)

3. Jupyterlab and several key extensions, key AI libraries - PyTorch and vLLM

![Install Jupyterlab](./images/install-local/12-jupyterlab-install.png)

4. Visual Studio Code and several key extensions, Aider

![Install VS Code](./images/install-local/13-vscode-install.png)

5. ollama

![Download ollama](./images/install-local/14-ollama-download.png)

6. 3 language models for chat, code and embeddings

![Download models](./images/install-local/15-models-download.png)

7. Open WebUI

![Install Open WebUI](./images/install-local/16-openwebui-install.png)

7. Open WebUI dependencies

![Init Open WebUI](./images/install-local/17-openwebui-init.png)

8. End of installation

![End of install](./images/install-local/18-end-of-install.png)

### Windows start and stop commands

1. Copy / paste the start command below in the terminal

```bash
set "WORDSLAB_WINDOWS_HOME=C:\wordslab" && call "%WORDSLAB_WINDOWS_HOME%\start-wordslab-notebooks.bat"
```

2. Personalize the installation paths on your computer

- set "WORDSLAB_WINDOWS_HOME=C:\wordslab" 

Press Enter to launch the startup script

=> The next startup steps will be executed automatically inside the Linux virtual machine without any user intervention

=> they are identical on a Windows or Linux machine, see below

### wordslab-notebooks startup steps

1. The server processes are launched one after the other and they display status messages in the terminal

![Start wordslab-notebooks](./images/install-local/19-start-wordslab-notebooks.png)


2. Check the messages displayed in the terminal until you see the following message 

```
------------------
Open the DASHBOARD
------------------
```

![Dashboard link](./images/install-local/20-dashboard-link.png)


3. Ctrl-clik on the link which is displayed just below to open the wordslab dashboard (or copy-paste this link in your browser)

```
http://127.0.0.1:8888
```

You should see the wordslab-notebooks dashboard

- Click on the 3 big tiles to launch the main wordslab applications
  - Chat => Open WebUI
  - Notebooks => JupyterLab
  - Code => Visual Studio

- Click on the links below "User applications" if you launched a user-specific server listening on $USER_APPn_PORT inside the virtual machine

- Check the CPU, GPU, and disk usage to manage your hardware resources

![Dashboard view](./images/install-local/21-dashboard-view.png)

4. To stop all the wordslab servers, just press simultaneously the following keys in the terminal window

```
[Ctrl]+[C]
```

![Stop all servers](./images/install-local/22-stop-all-servers.png)

5. **IMPORTANT** - If you are not running wordslab-notebooks on a local PC, don't forget to then go to your cloud provider website to shutdown your virtual machine !!

## Linux installation instructions

### Linux install commands

1. If you are not logged in as root, first make sure that you will execute the install script with administrator privileges

```bash
sudo bash
```

You will need to enter your password.

2. Copy / paste the installation command below in the terminal

```bash
apt update && apt install -y curl && export WORDSLAB_HOME=/home/wordslab && export WORDSLAB_WORKSPACE=$WORDSLAB_HOME/workspace && export WORDSLAB_MODELS=$WORDSLAB_HOME/models && export WORDSLAB_VERSION=2025-09 && curl -sSL https://raw.githubusercontent.com/wordslab-org/wordslab-notebooks/refs/tags/$WORDSLAB_VERSION/install-wordslab-notebooks.sh | bash
```

3. Personalize the installation paths on your computer, and select the version you want to install

- export WORDSLAB_HOME=/home/wordslab
- export WORDSLAB_WORKSPACE=$WORDSLAB_HOME/workspace 
- export WORDSLAB_MODELS=$WORDSLAB_HOME/models
- export WORDSLAB_VERSION=2025-09

Press Enter to launch the installation script

=> The next installation steps will be executed automatically without any user intervention

=> they are identical for a Windows or Linux install, see the section "wordslab-notebooks installation steps" above

### Linux start and stop commands

1. Copy / paste the start command below in the terminal

```bash
export WORDSLAB_HOME=/home/wordslab && $WORDSLAB_HOME/start-wordslab-notebooks.sh
```

2. Personalize the installation paths on your computer

- export WORDSLAB_HOME=/home/wordslab

Press Enter to launch the startup script

=> The next startup steps will be executed automatically without any user intervention

=> they are identical for a Windows or Linux machine, see the section "wordslab-notebooks startup steps" above

## Storage directories size (MB) - Version 2025-09

Please note that the exact install size will vary for each wordslab version and also depends on your GPU memory capacity (wordslab downloads bigger models by default if your GPU has more VRAM): the numbers below should be seen as a minimum.

Minimal install size = **30 GB** (8 GB GPU with small models)
Maximal install size = **60 GB** (24 GB GPU with bigger models)

### WORDSLAB_HOME disk

**20.2 GB**

System	
- Operating system:	1572
- Root user:	202

Applications	
- JupyterLab:	112
- Visual Studio:	447
- Ollama:	2609
- Open WebUI:	559

Python packages	
- torch-2.7.1+cu128:	1850
- vllm-0.10.1.1	1189:
- nvidia_cudnn_cu12-9.7.1.26:	1054
- nvidia_cublas_cu12-12.8.3.14:	857
- triton-3.3.1:	537
- nvidia_cusolver_cu12-11.7.2.55:	376
- nvidia_cusparse_cu12-12.5.7.53:	376
- xformers-0.0.31:	367
- open_webui-0.6.26:	286
- nvidia_cufft_cu12-11.3.3.41:	268
- nvidia_nccl_cu12-2.26.2:	260
- nvidia_cusparselt_cu12-0.6.3:	226
- cupy_cuda12x-13.6.0:	222
- nvidia_cuda_nvrtc_cu12-12.8.61:	211
- ... and many others

### WORDSLAB_WORKSPACE disk

**1.1 GB**

Workspace projects	
- wordslab-notebooks-tutorials:	218

Applications data	
- JupyterLab data:	0
- Visual Studio data:	332
- Open WebUI data:	464

### WORDSLAB_MODELS disk

**7.8 GB** for GPUs with 8 GB VRAM // **36.1 GB** for GPUs with 24 GB VRAM

Ollama models	
- gemma3:4b:	3184  // gemma3:27b:   16591
- qwen3:4b:     2381  // qwen3:30b:    17697
- qwen2.5-coder:1.5b-base:	940
- nomic-embed-text:latest:	261

vLLM models	

- Docling documents analysis models: 461


