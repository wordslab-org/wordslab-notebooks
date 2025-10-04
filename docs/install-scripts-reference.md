# Installation scripts documentation

Version: wordslab-notebooks 2025-10

## Table of contents

- [Windows installation scripts](#windows-installation-scripts)
  - [install-wordslab-notebooks.bat](#install-wordslab-notebooksbat)
  - [1_install-or-update-windows-subsystem-for-linux.bat](#1_install-or-update-windows-subsystem-for-linuxbat)
  - [1_install-or-update-windows-subsystem-for-linux.ps1](#1_install-or-update-windows-subsystem-for-linuxps1)
  - [2_create-linux-virtual-machine.bat](#2_create-linux-virtual-machinebat)
  - [3_create-linux-virtual-disks.bat](#3_create-linux-virtual-disksbat)
  - [4_mount-linux-virtual-disks.bat](#4_mount-linux-virtual-disksbat)
  - [5_install-linux-virtual-machine.bat](#5_install-linux-virtual-machinebat)
- [Linux installation scripts](#linux-installation-scripts)
  - [install-wordslab-notebooks.sh](#install-wordslab-notebookssh)
  - [1__update-operating-system.sh](#1__update-operating-systemsh)
  - [1_1_install-ubuntu-packages.sh](#1_1_install-ubuntu-packagessh)
  - [1_2_install-docker.sh](#1_2_install-dockersh)
  - [1_3_configure-shell-environment.sh](#1_3_configure-shell-environmentsh)
  - [2__install-wordslab-notebooks.sh](#2__install-wordslab-notebookssh)
  - [2_1_install-python-environment.sh](#2_1_install-python-environmentsh)
  - [2_2_install-dashboard.sh](#2_2_install-dashboardsh)
  - [2_3_install-jupyterlab.sh](#2_3_install-jupyterlabsh)
  - [2_3_jupyterlab-pyproject.toml](#2_3_jupyterlab-pyprojecttoml)
  - [2_4_create-workspace-project](#2_4_create-workspace-project)
  - [2_4_activate-workspace-project](#2_4_activate-workspace-project)
  - [2_4_delete-workspace-project](#2_4_delete-workspace-project)
  - [2_5_install-datascience-libs.sh](#2_5_install-datascience-libssh)
  - [2_5_datascience-pyproject.toml](#2_5_datascience-pyprojecttoml)
  - [3__install-vscode-server.sh](#3__install-vscode-serversh)
  - [3_1_install-vscode-server.sh](#3_1_install-vscode-serversh)
  - [3_2_install-aider-ai-agent.sh](#3_2_install-aider-ai-agentsh)
  - [4__install-open-webui.sh](#4__install-open-webuish)
  - [4_1_install-ollama.sh](#4_1_install-ollamash)
  - [4_2_install-open-webui.sh](#4_2_install-open-webuish)
  - [4_2_openwebui-pyproject.toml](#4_2_openwebui-pyprojecttoml)
  - [4_3_install-docling.sh](#4_3_install-doclingsh)
  - [4_3_docling-pyproject.toml](#4_3_docling-pyprojecttoml)
- [Windows startup scripts](#windows-startup-scripts)
  - [start-wordslab-notebooks.bat](#start-wordslab-notebooksbat)
  - [6_allow-remote-access-to-vm-ports.ps1](#6_allow-remote-access-to-vm-portsps1)
- [Linux startup scripts](#linux-startup-scripts)
  - [start-wordslab-notebooks.sh](#start-wordslab-notebookssh)
  - [5_start-wordslab-notebooks.sh](#5_start-wordslab-notebookssh)
  - [5_export-wordslab-urls.py](#5_export-wordslab-urlspy)
  - [5_1_start-docling-documents-extraction.sh](#5_1_start-docling-documents-extractionsh)
- [Windows multi-machine setup scripts](#windows-multi-machine-setup-scripts)
  - [prepare-client-machine.bat](#prepare-client-machinebat)
  - [prepare-server-secrets.bat](#prepare-server-secretsbat)
  - [prepare-server-machine.bat](#prepare-server-machinebat)

## Windows installation scripts

### install-wordslab-notebooks.bat

This batch script is a Windows-based installer for the WordsLab Notebooks environment that can install on both local Windows machines and remote Linux servers.

The script serves as a main entry point that determines whether to install locally on Windows or remotely on a Linux server based on command-line arguments.

#### Key Operations

##### 1. Command-Line Argument Parsing

- Local Windows Installation: `install-wordslab-notebooks.bat --cpu(optional) --name <wsl distribution name>(optional)`
- Remote Linux Installation: `install-wordslab-notebooks.bat <server address> <server ssh port>(optional)`

##### 2. Variables Setup

- Sets default values for installation parameters:
  - `name=wordslab-notebooks` (default WSL distribution name)
  - `cpu=true` (default to CPU-only installation)
  - `WORDSLAB_VERSION=2025-10` (default version tag)
  - Various Windows-specific paths for installation directories

##### 3.a Local Windows Installation Mode

When no arguments are provided (local mode):
- Validates required environment variables are set
- Downloads the appropriate version of the WordsLab Notebooks repository from GitHub
- Checks for NVIDIA GPU availability using `nvidia-smi`
- Parses command-line arguments to set installation options
- Creates a startup script (`start-wordslab-notebooks.bat`) with proper paths
- Executes a series of Windows-specific installation scripts in sequence:
  1. `1_install-or-update-windows-subsystem-for-linux.bat` - Installs or updates WSL
  2. `2_create-linux-virtual-machine.bat` - Creates the Linux VM
  3. `3_create-linux-virtual-disks.bat` - Creates virtual disks for workspace and models
  4. `4_mount-linux-virtual-disks.bat` - Mounts the virtual disks
  5. `5_install-linux-virtual-machine.bat` - Installs the full Linux environment

##### 3.b Remote Installation Mode (Linux Servers)

When arguments are provided for remote installation:
- Validates SSH key exists in the secrets directory
- Detects the remote platform by running commands on the remote server:
  - Windows Subsystem for Linux (WSL)
  - Jarvislabs.ai
  - Runpod.io
  - Vast.ai
  - Unknown Linux
- Sets appropriate `WORDSLAB_HOME` paths based on platform
- For Jarvislabs.ai, copies API key to remote server
- Executes installation script on remote server via SSH using curl

#### Key Technical Details

##### Installation Process Flow

1. Local Mode: 
   - Downloads wordslab scripts from GitHub
   - Installs WSL
   - Creates Linux VM
   - Creates and mounts virtual disks
   - Installs Linux environment

2. Remote Mode:
   - Validates SSH access
   - Detects platform
   - Sets up platform-specific paths
   - Executes installation script on remote server via curl

This script provides a unified interface for installing the WordsLab Notebooks environment across different platforms while handling the complexity of cross-platform installation requirements.

##### Platform Detection

The script uses SSH to run platform detection commands on remote servers, identifying:
- Microsoft Windows Subsystem for Linux
- Jarvislabs.ai cloud platform
- Runpod.io cloud platform
- Vast.ai cloud platform

##### Github Version Management

Supports both:
- `main` branch for latest development version
- Specific version tags (like `2025-10`) for stable releases

##### GPU Detection

On Windows, the script checks for NVIDIA GPU availability and automatically sets CPU mode to false if a GPU is detected.

##### Security Considerations

- Requires SSH keys in a dedicated `secrets` directory
- Uses `StrictHostKeyChecking=no` for automated SSH connections
- Validates required API keys for Jarvislabs.ai platform

### 1_install-or-update-windows-subsystem-for-linux.bat

This is a simple batch script that serves as a wrapper for a PowerShell script to install or update Windows Subsystem for Linux (WSL). 

#### Key Operations

1. PowerShell Execution:
   - Calls `PowerShell -ExecutionPolicy Bypass -File .\1_install-or-update-windows-subsystem-for-linux.ps1`
   - Uses `-ExecutionPolicy Bypass` to allow execution of the PowerShell script without requiring elevated permissions or changing system-wide execution policies
   - Executes the PowerShell script located in the same directory

2. Error Handling:
   - Checks the exit code (`%ERRORLEVEL%`) from the PowerShell script
   - If the PowerShell script fails (non-zero exit code), it exits the batch script with the same error code

#### Integration with Installation Flow

This script is the first step in the Windows installation sequence:
1. `1_install-or-update-windows-subsystem-for-linux.bat` - Ensures WSL is available
2. `2_create-linux-virtual-machine.bat` - Creates the Linux VM
3. `3_create-linux-virtual-disks.bat` - Creates virtual disks
4. `4_mount-linux-virtual-disks.bat` - Mounts virtual disks
5. `5_install-linux-virtual-machine.bat` - Installs the full Linux environment

The batch wrapper ensures that the PowerShell-based WSL installation is properly executed as part of the larger installation workflow.

### 1_install-or-update-windows-subsystem-for-linux.ps1

This PowerShell script is designed to install or update Windows Subsystem for Linux (WSL) on a Windows machine, with specific optimizations forNVIDIA GPU compatibility.

The script checks whether WSL is already installed on the system. If not, it installs WSL2 without a default Linux distribution, configures WSL to use most of the system's available RAM (minus 2 GB), and prompts the user to reboot the system. If WSL is already installed, it simply updates it to the latest version.

#### Key Operations

##### 1. Prerequisites

Before running this script, the user must:
- Update Windows to the latest version using:
  ```powershell
  start ms-settings:windowsupdate
  ```
- Update the NVIDIA GPU driver using:
  ```powershell
  "C:\Program Files\NVIDIA Corporation\NVIDIA GeForce Experience\NVIDIA GeForce Experience.exe"
  ```

> These steps are necessary because WSL2 has known compatibility issues with older Windows versions and outdated graphics drivers.

##### 2. Check WSL Status

- Runs `wsl --status` to check if WSL is installed and working.

##### 3. Install WSL Without Distribution (Is not Already Installed)

- Installs WSL2 but does not install a default Linux distribution.

##### 4. Configure WSL Memory Usage

- Calculates total physical memory and sets WSL2 to use that amount minus 2 GB.
- Creates or modifies `.wslconfig` in the user profile directory to configure memory limits.

> This is important for performance when using WSL2 with resource-intensive applications like Docker, ML frameworks, etc.

##### 5. Reboot Prompt

- Informs the user that a reboot is required.
- Asks for confirmation before rebooting.
- If declined, exits the script.

##### 6. Update WSL (If Already Installed)

- If WSL is already installed, it runs `wsl --update` to ensure the latest version is installed.

#### Key Technical Details

| Feature | Description |
|--------|-------------|
| **Target Platform** | Windows 10/11 with WSL2 support |
| **WSL Version** | WSL2 |
| **Installation Mode** | Installs WSL2 only (no default Linux distro) |
| **Memory Allocation** | Uses total system RAM minus 2 GB for WSL2 |
| **Configuration File** | `.wslconfig` in `%USERPROFILE%` |
| **Reboot Requirement** | Required after initial WSL install |
| **User Interaction** | Asks for reboot confirmation |

### 2_create-linux-virtual-machine.bat

This batch script creates a Linux virtual machine using Windows Subsystem for Linux (WSL) by importing an Ubuntu Linux distribution.

#### Key Operations

##### 1. Parameter Validation

- Requires the WSL distribution name as a command-line argument (`%1`)
- This name is used to identify the specific WSL instance (e.g., "wordslab-notebooks")

##### 2. Check if VM Already Exists

- Uses `wsl -d %1 -- : >nul` to test if the distribution already exists
- If the command fails (errorlevel ≠ 0), it means the VM doesn't exist and needs to be created

##### 3. VM Creation Process

When VM doesn't exist:
- Creates directory structure: `mkdir %WORDSLAB_WINDOWS_HOME%\virtual-machines\%1`
- Downloads Ubuntu base image: 
  - Downloads `ubuntu-noble.tar` from Canonical's partner images repository
  - Uses Ubuntu Noble (24.04 LTS) as the base Linux distribution
- Imports the VM: 
  - Uses `wsl --import` command to create the WSL distribution
  - Imports the downloaded tar.gz image into the specified directory
- Cleanup: Deletes the downloaded tar file after import

##### 4. Initial Configuration

- Creates a configuration file: Writes the Windows home directory path to `/home/.WORDSLAB_WINDOWS_HOME` inside the Linux VM
- Purpose: This file serves as a reference point for the Windows installation path, allowing the Linux environment to know where Windows files are located

#### Key Technical Details

##### WSL Import Process

- Uses `wsl --import` which is the standard WSL command for creating new distributions
- The import process creates a complete Linux filesystem from the tarball
- The VM is stored in the Windows directory structure under `%WORDSLAB_WINDOWS_HOME%\virtual-machines\%1`

##### Ubuntu Noble Base Image

- Downloads Ubuntu 24.04 LTS (Noble) from Canonical's official partner images
- This provides a modern, stable Linux environment for the notebooks
- Uses the OCI (Open Container Initiative) format for the base image

##### Path Handling

- Creates a reference file that allows Linux processes to access Windows paths

#### Integration in Installation Flow

This script is the second step in the Windows installation sequence:
1. `1_install-or-update-windows-subsystem-for-linux.bat` - Ensures WSL is available
2. `2_create-linux-virtual-machine.bat` - Creates the Linux VM (this script)
3. `3_create-linux-virtual-disks.bat` - Creates virtual disks
4. `4_mount-linux-virtual-disks.bat` - Mounts virtual disks
5. `5_install-linux-virtual-machine.bat` - Installs the full Linux environment

### 3_create-linux-virtual-disks.bat

This batch script creates two separate Linux virtual disks using WSL for storing workspace and models data. 

#### Key Operations

##### 1. Parameter and Environment Validation

- No command-line parameters required
- Requires two environment variables:
  - `%WORDSLAB_WINDOWS_WORKSPACE%`: Directory for workspace virtual disk
  - `%WORDSLAB_WINDOWS_MODELS%`: Directory for models virtual disk

##### 2. Check if Virtual Disks Already Exist

- Uses `wsl -d wordslab-notebooks-workspace -- : >nul` to test if workspace VM already exists
- If the command fails (errorlevel ≠ 0), it means the VMs don't exist and need to be created

##### 3. Virtual Disk Creation Process

When VMs don't exist:
- Downloads Alpine Linux base image:
  - Downloads `alpine.tar` from Alpine Linux CDN (version 3.22)
  - Uses Alpine Linux (minimal Linux distribution) for lightweight virtual disks
- Creates workspace disk:
  - Creates directory: `mkdir %WORDSLAB_WINDOWS_WORKSPACE%`
  - Imports Alpine image as WSL distribution: `wsl --import wordslab-notebooks-workspace %WORDSLAB_WINDOWS_WORKSPACE% alpine.tar`
- Creates models disk:
  - Creates directory: `mkdir %WORDSLAB_WINDOWS_MODELS%`
  - Imports Alpine image as WSL distribution: `wsl --import wordslab-notebooks-models %WORDSLAB_WINDOWS_MODELS% alpine.tar`
- Cleanup: Deletes the downloaded tar file after both imports

##### 4. Directory Setup in Linux Environments

- Creates mount points:
  - `wsl -d wordslab-notebooks-workspace -- mkdir -p /home/workspace`
  - `wsl -d wordslab-notebooks-models -- mkdir -p /home/models`
- Creates reference files that allows Linux processes to access Windows paths:
  - /home/workspace/.WORDSLAB_WINDOWS_WORKSPACE
  - /home/models/.WORDSLAB_WINDOWS_MODELS

#### Key Technical Details

This script establishes separate storage volumes for:
- Workspace data: Notebooks, scripts, and user-created content
- Models data: Large machine learning models and datasets
- This separation provides better organization, potential for different storage strategies, and cleaner data management

The virtual disks are created as separate WSL distributions, allowing them to be mounted and accessed as distinct storage volumes within the larger WordsLab environment.

##### Alpine Linux Base

- Uses Alpine Linux (minimal Linux distribution) for virtual disks
- Much smaller than Ubuntu, making it more efficient for data storage
- `alpine-minirootfs-3.22.1-x86_64.tar.gz` provides a minimal root filesystem

##### Separate Storage Volumes

- Workspace disk: Dedicated storage for notebooks, code, and user data
- Models disk: Dedicated storage for large model files and datasets
- This separation allows for better organization and potentially different storage strategies

##### Path Reference Files

- Creates `.WORDSLAB_WINDOWS_WORKSPACE` and `.WORDSLAB_WINDOWS_MODELS` files in each disk
- These files contain the Windows host paths for the respective disks
- Allows Linux environments to reference and access the Windows host directories

#### Integration in Installation Flow

This script is the third step in the Windows installation sequence:
1. `1_install-or-update-windows-subsystem-for-linux.bat` - Ensures WSL is available
2. `2_create-linux-virtual-machine.bat` - Creates the main Linux VM
3. `3_create-linux-virtual-disks.bat` - Creates separate virtual disks (this script)
4. `4_mount-linux-virtual-disks.bat` - Mounts the virtual disks
5. `5_install-linux-virtual-machine.bat` - Installs the full Linux environment

### 4_mount-linux-virtual-disks.bat

This batch script establishes bidirectional mounting between the WSL virtual disks and the main WordsLab Notebooks WSL distribution. 

#### Key Operations

##### 1. Parameter Handling

- Takes a WSL distribution name as a command-line parameter (`%name%`)
- This parameter refers to the main WordsLab Notebooks distribution (e.g., "wordslab-notebooks")

##### 2. Mounting Process for Workspace Disk

For the workspace virtual disk:
- Creates mount point in workspace VM: `wsl -d wordslab-notebooks-workspace -- mkdir -p /mnt/wsl/wordslab-notebooks-workspace`
- Binds workspace directory: `wsl -d wordslab-notebooks-workspace -- mount --bind /home/workspace /mnt/wsl/wordslab-notebooks-workspace`
- Creates mount point in main VM: `wsl -d %name% -- mkdir -p /home/workspace`
- Binds mount point: `wsl -d %name% -- mount --bind /mnt/wsl/wordslab-notebooks-workspace /home/workspace`

##### 3. Mounting Process for Models Disk

For the models virtual disk:
- Creates mount point in models VM: `wsl -d wordslab-notebooks-models -- mkdir -p /mnt/wsl/wordslab-notebooks-models`
- Binds models directory: `wsl -d wordslab-notebooks-models -- mount --bind /home/models /mnt/wsl/wordslab-notebooks-models`
- Creates mount point in main VM: `wsl -d %name% -- mkdir -p /home/models`
- Binds mount point: `wsl -d %name% -- mount --bind /mnt/wsl/wordslab-notebooks-models /home/models`

#### Key Technical Details

- The main WSL distribution can now access both workspace and models data
- Data remains physically separated in different virtual disks for organization and potential different storage strategies
- The mounting system provides transparent access to all data from the main environment

##### Bind Mounting

- Uses `mount --bind` to create bind mounts
- This creates a "mirror" of directories so that changes in one location are reflected in the other
- Allows the main WSL distribution to access data from the separate workspace and models disks

##### Directory Structure

- Workspace disk: `/home/workspace` (in workspace VM) → `/mnt/wsl/wordslab-notebooks-workspace` → `/home/workspace` (in main VM)
- Models disk: `/home/models` (in models VM) → `/mnt/wsl/wordslab-notebooks-models` → `/home/models` (in main VM)

#### Integration in Installation Flow

This script is the fourth step in the Windows installation sequence:
1. `1_install-or-update-windows-subsystem-for-linux.bat` - Ensures WSL is available
2. `2_create-linux-virtual-machine.bat` - Creates the main Linux VM
3. `3_create-linux-virtual-disks.bat` - Creates separate virtual disks
4. `4_mount-linux-virtual-disks.bat` - Mounts the virtual disks (this script)
5. `5_install-linux-virtual-machine.bat` - Installs the full Linux environment

### 5_install-linux-virtual-machine.bat

This batch script performs the final installation step in the WordsLab Notebooks Windows setup process, executing the main Linux installation script within the specified WSL distribution.

#### Key Operations

##### 1. Parameter Handling

- Required parameters:
  - `%1`: WSL distribution name (e.g., "wordslab-notebooks")
  - `%2`: CPU-only flag (likely "true" or "false" to determine if CUDA support should be installed)
- Uses `%1` as the target WSL distribution for installation

##### 2. Main Installation Execution

- Command: `wsl -d %1 -- WORDSLAB_VERSION=%WORDSLAB_VERSION% ./install-wordslab-notebooks.sh %2`
- Executes the `install-wordslab-notebooks.sh` script within the specified WSL distribution
- Environment variable: Sets `WORDSLAB_VERSION=%WORDSLAB_VERSION%` for the installation
- Script parameter: Passes `%2` (CPU-only flag) to the installation script

> See the **Linux installation scripts** section below for the documentation of **install-wordslab-notebooks.sh**.

#### Key Technical Details

- Completes the installation of the WordsLab Notebooks environment
- Installs all necessary packages, dependencies, and configurations
- Sets up the complete Linux environment with the appropriate compute capabilities

##### WSL Command Structure

- `wsl -d %1 --` - Executes command in specified WSL distribution
- `WORDSLAB_VERSION=%WORDSLAB_VERSION%` - Sets environment variable in the WSL context
- `./install-wordslab-notebooks.sh %2` - Runs the main installation script with CPU-only parameter

##### Mounting Constraint
- The script includes a comment noting that `WORDSLAB_WORKSPACE` or `WORDSLAB_MODELS` default paths cannot be changed in the WSL virtual machine
- This is crucial because changing these paths would break the mounting system established in step 4 (`4_mount-linux-virtual-disks.bat`)
- This constraint ensures that the mounting system continues to work properly

#### Integration in Installation Flow

This script is the final step in the Windows installation sequence:
1. `1_install-or-update-windows-subsystem-for-linux.bat` - Ensures WSL is available
2. `2_create-linux-virtual-machine.bat` - Creates the main Linux VM
3. `3_create-linux-virtual-disks.bat` - Creates separate virtual disks
4. `4_mount-linux-virtual-disks.bat` - Mounts the virtual disks
5. `5_install-linux-virtual-disks.bat` - Installs the full Linux environment (this script)


## Linux installation scripts

### install-wordslab-notebooks.sh

This is the main installation script for the WordsLab Notebooks environment on Linux. It's a comprehensive setup script that downloads, configures, and installs the complete WordsLab ecosystem with all its components.

- Installs complete AI/ML development environment
- Includes JupyterLab, VS Code server, Open WebUI, Ollama
- Sets up data science libraries and tools

This script serves as the complete installation solution for the WordsLab Notebooks ecosystem, transforming a fresh system into a fully-featured AI development environment with all necessary tools and services pre-configured.

#### Key Operations

###### 1. Environment Configuration

- Sets default values for `WORDSLAB_HOME` (default: `/home`) and `WORDSLAB_VERSION` (default: `2025-10`)
- Supports customization through environment variables for installation paths
- Prepares the installation directory structure

##### 2. Installation scripts Acquisition

- Downloads the WordsLab Notebooks scripts from GitHub
- Supports both main branch and tagged releases via `WORDSLAB_VERSION` parameter
- Unzips the downloaded archive and cleans up temporary files

##### 3. Environment Variable Management

- Backs up the existing `_wordslab-notebooks-env.bashrc` file
- Iterates through current environment variables to find WORDSLAB-specific variables
- Updates the bashrc file with current environment settings
- Sources the updated environment variables for immediate use

##### 4. System Prerequisites Installation

- Updates Ubuntu package lists and installs essential packages (curl, unzip)
- Runs `1__update-operating-system.sh` to install necessary system packages
- Installs Python environment and data science libraries via `2__install-wordslab-notebooks.sh`

##### 5. Component Installation

Sequentially installs all major components:
- Notebooks Environment: Python, JupyterLab, dashboard, data science libraries
- Code Environment: VS Code server, Aider AI agent
- Chat/LLM Environment: Open WebUI, Ollama

##### 6. Shell Configuration

- Configures the shell environment for new sessions
- Sets up proper directory navigation and environment activation
- Updates `.bashrc` to ensure new shells start in the correct environment

##### 7. Startup Script Generation

- Creates a convenient startup script at `$WORDSLAB_HOME/start-wordslab-notebooks.sh`
- Sets proper environment variables and directory paths
- Makes the script executable

### 1__update-operating-system.sh

Updates and configures the Linux operating system environment, installing necessary packages and setting up containerization capabilities for the WordsLab Notebooks environment.

#### Key Operations

##### 1. Parameter Handling

- Input parameter: `cpu_only=$1` - Determines whether to install CPU-only or GPU-enabled configurations
- If `cpu_only` is set to "true", installs only CPU capabilities
- If `cpu_only` is set to "false" or any other value, installs GPU capabilities with NVIDIA support

##### 2. Package Installation

- Calls: `./1_1_install-ubuntu-packages.sh`
- Installs all required Ubuntu/Debian packages needed for WordsLab Notebooks
- This is a prerequisite step for the entire environment

##### 3. Docker Installation

- Conditional execution: Only installs Docker if NOT inside a Docker container (`[ ! -f /.dockerenv ]`)
- Docker setup: `./1_2_install-docker.sh`
- NVIDIA runtime: Only installs NVIDIA container runtime when GPU support is requested (`! "$cpu_only" == "true"`)

Notes
- Uses `/.dockerenv` file check to detect if running inside a Docker container
- This prevents Docker installation within Docker containers (which would cause conflicts)
- Standard approach for detecting container environments
- CPU-only mode: When `cpu_only=true`, only installs basic packages and Docker
- GPU mode: When `cpu_only=false`, installs NVIDIA container runtime for GPU acceleration
- Allows flexible deployment based on user's hardware capabilities
- 
##### 4. Installation Tracking

- Creates marker file: `touch /.wordslab-installed`
- This prevents the script from running multiple times unnecessarily
- Acts as a flag to remember that the operating system was already updated
- Prevents redundant package installations and potential conflicts

##### Cloud virtual machines

- Includes a note: "NB: you need to re-execute this script each time the container image is reset"
- Indicates that if the container image is reset or rebuilt, this script must be re-run
- This is important for containerized environments where images might be recreated

### 1_1_install-ubuntu-packages.sh

This script installs the foundational software environment needed for the WordsLab Notebooks platform, providing developers with essential tools for coding, system administration, network troubleshooting, and multimedia processing - all while maintaining a minimal, efficient installation that supports the subsequent Python environment and notebook workflows.

#### Key Operations

##### 1. System Configuration

- Sets `DEBIAN_FRONTEND=noninteractive` to prevent interactive prompts during installation
- Configures locale settings (`en_US.UTF-8`) for proper text encoding

##### 2. Essential Utilities

- Basic system tools: `sudo`, `apt-utils`, `locales` - core system components
- Text editors: `less`, `vim`, `tmux`, `screen` - for file editing and terminal management
- Network tools: `ca-certificates`, `curl`, `wget`, `unzip`, `openssh-client` - for downloading and network operations
- Monitoring tools: `htop`, `nvtop`, `iputils-ping`, `net-tools`, `traceroute` - for system monitoring and network diagnostics

##### 3. Development Tools

- Version control: `git`, `git-lfs` - for source code management
- Build tools: `build-essential`, `cmake` - for compiling software
- Media processing: `ffmpeg` - for audio/video processing

##### 4. Optional Documentation Tools

- Contains commented-out lines for installing `pandoc` and LaTeX packages that would enable PDF/HTML notebook generation

### 1_2_install-docker.sh

This script establishes the containerization infrastructure needed for the WordsLab Notebooks platform. Docker enables:
- Isolated development environments
- Consistent deployment across different systems
- Efficient resource utilization
- Container-based workflows for machine learning and data processing tasks

The installation is designed to be idempotent and follows Docker's official installation guidelines for Ubuntu systems.

#### Key Operations

##### 1. GPG Key Setup

- Checks if Docker's official GPG key already exists at `/etc/apt/keyrings/docker.asc`
- If the key doesn't exist, it:
  - Creates the `/etc/apt/keyrings` directory with proper permissions
  - Downloads Docker's official GPG key from `https://download.docker.com/linux/ubuntu/gpg`
  - Sets appropriate read permissions on the key file

##### 2. Repository Configuration

- Adds Docker's official repository to the APT sources list
- Uses the system's version codename to ensure compatibility
- Configures the repository with the correct architecture and signing key

##### 3. Docker Installation

- Updates the package index
- Installs the following Docker components:
  - `docker-ce` - Docker Engine (core container engine)
  - `docker-ce-cli` - Docker Command Line Interface
  - `containerd.io` - Container runtime
  - `docker-buildx-plugin` - Enhanced build capabilities
  - `docker-compose-plugin` - Docker Compose functionality

### 1_3_configure-shell-environment.sh

This script ensures that:
- Users have access to WordsLab-specific environment variables and aliases
- The correct Python environment is activated automatically
- The proper working directory is set
- Installation version tracking is maintained for update purposes
- Shell configuration persists across sessions

The script essentially "glues" the WordsLab environment into the user's shell session, making the installed tools and configurations immediately available.

#### Key Operations

##### 1. Environment Configuration

- Appends sourcing commands to `~/.bashrc` to load two specific configuration files:
  - `_wordslab-notebooks-env.bashrc` - Sets environment variables for storage paths and ports
  - `_wordslab-notebooks-init.bashrc` - Initializes the shell with proper Python environment and working directory

##### 2. Installation Tracking

- Creates a marker file `~/.wordslab-installed` containing the current `WORDSLAB_VERSION`
- This flag distinguishes between first-time installations and subsequent updates

##### 3. Important Notes

- Includes a warning that this script should only be run after:
  - `2__install-wordslab-notebooks.sh` (installs WordsLab Notebooks)
  - `3__install-open-webui.sh` (installs Open WebUI)
- Mentions that commands accumulate in `.bashrc` with newer versions overwriting older ones
- The script is designed to be run as part of the installation sequence

### 2__install-wordslab-notebooks.sh

This script creates a complete, self-contained Python development environment for WordsLab Notebooks that includes:
- Isolated Python environments
- JupyterLab with proper configuration
- Data science libraries (PyTorch, etc.)
- Project-specific virtual environments and kernels
- Proper storage location configuration for notebooks, models, and datasets
- GPU support (when available) with conditional installation

The script serves as the main orchestrator for building the core computational environment needed for machine learning and data science workloads within the WordsLab platform.

- Takes `cpu_only` parameter to determine whether to install GPU-specific components (like VLLM)

#### Key Operations

##### 1. Python Environment Setup

- Calls `2_1_install-python-environment.sh` to install and configure a Python environment manager (likely conda/Miniconda)
- Sources the UV installation to add it to the PATH

##### 2. Dashboard Installation

- Executes `2_2_install-dashboard.sh` to install the WordsLab Notebooks dashboard

##### 3. JupyterLab Setup

- Runs `2_3_install-jupyterlab.sh` to install JupyterLab and useful extensions
- Configures JupyterLab to store all its state under the `$WORDSLAB_WORKSPACE` directory

##### 4. Workspace Configuration

- Calls `2_4_setup-workspace-projects.sh` to create virtual Python environments and IPython kernels for each project

##### 5. Data Science Libraries

- Executes `2_5_install-datascience-libs.sh $cpu_only` to install:
  - Basic data science libraries
  - PyTorch
  - VLLM (only for GPU installations)
  - Configures popular deep learning libraries to download models and datasets from `$WORDSLAB_MODELS` directory

### 2_1_install-python-environment.sh

This script establishes the Python environment foundation for WordsLab Notebooks by:

1. Installing uv: A fast Python package manager and installer that provides:
   - Fast package installation and dependency resolution
   - Virtual environment management
   - Python version management
   - Modern Python workflow tools

2. Setting Python Version: Installs a specific Python version (3.12.11) that will be used consistently across the WordsLab environment

#### Key Operations

##### 1. uv Installation

- Creates the installation directory specified by `$UV_INSTALL_DIR` (if it doesn't exist)
- Downloads and installs `uv` using the official installation script from `https://astral.sh/uv/install.sh`
- Sources the environment file (`$UV_INSTALL_DIR/env`) to make `uv` available in the current shell

Using `uv` instead of traditional `pip` or `conda` provides:
- Significantly faster installation times
- Better dependency resolution
- Modern Python packaging standards
- Integrated virtual environment management
- Cross-platform compatibility

This creates a solid foundation for the subsequent Python package installations in the WordsLab environment, ensuring consistent package management and Python version control across all components.

##### 2. Python Version Management

- Installs Python version 3.12.11 using `uv python install 3.12.11`

### 2_2_install-dashboard.sh

Installs wordslab notebooks dashboard, a FastHTML web appplication
- cd $WORDSLAB_SCRIPTS/dashboard
- uv sync

#### Key Features

The key features of the dashboard are:

1. It displays system information such as CPU model, vendor, core count, frequency, usage percentage, and RAM utilization.

2. If available, it shows GPU details like model name, CUDA version, VRAM total and used size, and usage percentage.

3. Disk usage is monitored for both Linux disks (system, root user, Python packages, Wordslab software) and Windows disks (if applicable), including their sizes and usage percentages.

4. It provides information about storage directories in the virtual machine, such as JupyterLab, VSCode/Code Server, Ollama, Open WebUI, workspace projects, Ollama models, and Hugging Face models, along with their respective sizes.

5. The dashboard is built using FastHTML for the user interface and utilizes various libraries like psutil, pynvml, subprocess, os, etc., to fetch system information.

6. It periodically updates the displayed metrics by making HTTP requests to specific endpoints ("/cpu", "/gpu", "/vmdisks", "/windisks", "/knowndirs") at regular intervals (e.g., every 1 second for CPU/GPU, every 60 seconds for disks and known directories).

7. The dashboard allows accessing external applications like Open WebUI, JupyterLab, Visual Studio Code Server through clickable links.

### 2_3_install-jupyterlab.sh

This script establishes a complete, persistent JupyterLab environment that:
- Stores all JupyterLab data in the designated workspace directory
- Ensures consistent configuration across installations
- Uses `uv` for fast, reliable package installation
- Provides a controlled environment for notebook development

The configuration ensures that all JupyterLab state, settings, and extensions are properly managed within the WordsLab storage structure, making the environment portable and consistent.

#### Key Operations

##### 1. Directory Preparation

- Creates the main workspace directory (`$WORDSLAB_WORKSPACE`) if it doesn't exist
- Creates a persistent `.secrets` directory under workspace for storing application secrets

##### 2. JupyterLab Configuration

- Modifies `_wordslab-notebooks-env.bashrc` to set various JupyterLab directory environment variables:
  - `JUPYTER_CONFIG_DIR` - Configuration directory
  - `JUPYTER_DATA_DIR` - Data directory
  - `JUPYTER_RUNTIME_DIR` - Runtime directory
  - `JUPYTERLAB_SETTINGS_DIR` - User settings directory
  - `JUPYTERLAB_WORKSPACES_DIR` - Workspaces directory
- This ensures all JupyterLab state is stored under the controlled `$WORDSLAB_WORKSPACE` directory

##### 3. Environment Setup

- Creates the JupyterLab environment directory (`$JUPYTERLAB_ENV`)
- Copies the `2_3_jupyterlab-pyproject.toml` configuration file to the environment directory
- Uses `uv sync` to download and install JupyterLab and all its extensions

### 2_3_jupyterlab-pyproject.toml

This configuration file serves as the dependency specification for the JupyterLab environment, ensuring that:

1. Consistent Installation: All required packages are installed with specified versions
2. Environment Isolation: Creates a self-contained JupyterLab environment
3. Feature Richness: Provides a comprehensive set of tools including:
   - Core notebook functionality
   - Data visualization capabilities
   - Git integration
   - GPU monitoring
   - AI/ML extensions
   - Language model integrations

#### Key Operations

##### 1. Project Metadata

- name: "jupyterlab-env" - Identifies the environment name
- description: "wordslab-notebooks jupyterlab environment" - Purpose description
- requires-python: ">=3.12,<3.13" - Specifies Python version compatibility (3.12.x series)

##### 2. Dependencies

The file lists 9 key packages:
- jupyterlab==4.4.9 - Core JupyterLab application
- ipympl==0.9.7 - Interactive matplotlib widget for Jupyter
- jupyterlab-execute-time==3.2.0 - Shows execution time of cells
- jupyterlab-git==0.51.2 - Git integration for JupyterLab
- jupyterlab-nvdashboard==0.13.0 - NVIDIA dashboard for monitoring GPU usage
- pynvml==12.0.0 - Python bindings for NVIDIA Management Library
- jupyter-ai==2.31.6 - AI assistant extension for JupyterLab
- langchain-ollama==0.3.8 - LangChain integration with Ollama
- langchain-openai==0.3.33 - LangChain integration with OpenAI

#### Integration with Installation Flow

When `2_3_install-jupyterlab.sh` runs `uv sync`, it reads this configuration file to:
- Resolve and install all specified dependencies
- Create a consistent, reproducible JupyterLab environment
- Ensure all extensions are properly configured and available

This file essentially defines the "recipe" for building the WordsLab Notebooks JupyterLab environment with all the necessary tools for data science and AI development work.

### 2_4_create-workspace-project

This script serves as a utility for developers working with multiple projects in the WordsLab environment by automating the creation of new projects within the WordsLab workspace, setting up proper directory structure, version control, Python environments, and Jupyter kernel integration.

This script streamlines the project creation workflow by:

1. Automated Setup: Creates complete project environments with one command
2. Version Control: Initializes Git repositories with proper ignore rules
3. Environment Isolation: Creates project-specific Python virtual environments
4. Jupyter Integration: Makes project environments available as Jupyter kernels
5. Flexibility: Supports both Git repository cloning and empty project creation
6. Consistency: Ensures all projects follow the same structure and setup patterns

#### Key Operations

##### 1. Parameter Handling

- Accepts one or two arguments:
  - First argument: Project name or Git repository URL
  - Second argument (optional): Custom project directory name for Git repositories
- Provides usage instructions if no arguments are given
- Validates that the project directory doesn't already exist

##### 2. Project Directory Creation

- Creates the project directory in `$WORDSLAB_WORKSPACE`
- Changes to the new project directory
- Handles both Git repository cloning and empty project initialization

##### 3. Git Repository Setup

- Clones Git repositories when a `.git` URL is provided
- Initializes empty Git repositories for new projects
- Adds `.venv` to `.gitignore` to prevent virtual environment from being tracked

##### 4. Python Virtual Environment Creation

The script uses `uv` (a fast Python package manager) to create project-specific environments with different strategies based on project files:

If `pyproject.toml` exists:
- Adds `ipykernel` dependency
- Uses `uv sync` with appropriate CUDA/CPU extras

If `requirements.txt` exists:
- Creates virtual environment with `uv venv`
- Synchronizes dependencies with `uv pip sync`
- Installs `ipykernel` for Jupyter integration

If neither file exists:
- Copies a default `2_5_datascience-pyproject.toml` template
- Renames the project in the template
- Uses `uv sync` with appropriate extras

##### 5. Jupyter Kernel Integration

- Installs a Jupyter kernel named after the project
- This allows selecting the project-specific environment when creating new notebooks

####  Usage Examples

```bash
# Create empty project
create-workspace-project myproject

# Clone Git repository (uses repo name as directory)
create-workspace-project https://github.com/fastai/fastbook.git

# Clone Git repository with custom directory name
create-workspace-project https://github.com/fastai/fastbook.git mybook
```

#### Integration with Workspace Structure

The script works within the WordsLab ecosystem by:
- Placing projects in `$WORDSLAB_WORKSPACE` for consistent storage
- Using the established virtual environment and kernel infrastructure
- Leveraging the existing `$WORDSLAB_WORKSPACE/.cpu-only` flag for hardware detection
- Maintaining compatibility with the broader WordsLab installation process

This enables developers to quickly spin up new projects with properly configured environments, dependencies, and Jupyter integration while maintaining the isolated, reproducible nature of the WordsLab workspace.

### 2_4_activate-workspace-project

This script serves as a utility for developers working with multiple projects in the WordsLab environment by:

1. Project Isolation: Ensures each project has its own isolated Python environment
2. Easy Activation: Provides a simple command to switch between different project environments
3. Workspace Integration: Works seamlessly with the WordsLab workspace structure
4. Consistent Workflow: Standardizes how developers activate project-specific environments

#### Key Operations

##### 1. Parameter Validation

- Checks if a project directory name is provided as the first argument
- Displays usage instructions if no argument is given
- Validates that the specified project directory exists within `$WORDSLAB_WORKSPACE`

##### 2. Directory Navigation

- Changes to the specified project directory (`$WORDSLAB_WORKSPACE/$dir_name`)

##### 3. Environment Activation

- Activates the Python virtual environment located at `.venv/` within the project directory
- Prints a confirmation message indicating which project environment is being activated

#### Usage Example

```bash
# Activate a project named "myproject"
source activate-workspace-project myproject

# This would activate the environment at:
# $WORDSLAB_WORKSPACE/myproject/.venv/bin/activate
```

#### Integration with Workspace Structure

The script assumes:
- Projects are organized as subdirectories within `$WORDSLAB_WORKSPACE`
- Each project directory contains a `.venv` directory with a Python virtual environment

This enables developers to work on multiple projects with different Python dependencies without conflicts, maintaining the isolation benefits of virtual environments while working within the structured WordsLab workspace.

### 2_4_delete-workspace-project

This script provides a clean way to completely remove projects from the WordsLab workspace, ensuring that both the project files and associated Jupyter kernel configurations are properly deleted.

This script serves as a safe and complete project cleanup tool by:

1. Preventing Orphaned Kernels: Ensures Jupyter doesn't have references to deleted environments
2. Complete Removal: Deletes all traces of the project including files, virtual environments, and kernel configurations
3. Workspace Maintenance: Helps keep the workspace clean and organized
4. Resource Management: Frees up disk space by removing unused projects

#### Key Operations

##### 1. Parameter Validation

- Checks if a project directory name is provided as the first argument
- Displays usage instructions if no argument is given
- Validates that the specified project directory exists within `$WORDSLAB_WORKSPACE`

##### 2. Jupyter Kernel Cleanup

- Activates the project environment using the existing `activate-workspace-project` script
- Uninstalls the Jupyter kernel associated with the project using `jupyter kernelspec uninstall -y $dir_name`
- This prevents orphaned kernel references in JupyterLab

##### 3. Project Directory Deletion

- Deletes the entire project directory including all files and subdirectories
- Uses `rm -rf` to recursively remove the directory and its contents
- Removes both the project files and the associated virtual environment

#### Usage Example

```bash
# Delete a project named "myproject"
delete-workspace-project myproject

# This would:
# 1. Uninstall the "myproject" Jupyter kernel
# 2. Delete the entire $WORDSLAB_WORKSPACE/myproject directory
```

#### Integration with Workspace Structure

The script works within the WordsLab ecosystem by:
- Operating on projects within `$WORDSLAB_WORKSPACE`
- Using the established kernel management system
- Leveraging the existing project activation infrastructure
- Maintaining consistency with the overall workspace management approach

This script provides a clean way to manage the lifecycle of projects in the WordsLab workspace, allowing developers to remove projects completely while maintaining system integrity.

### 2_5_install-datascience-libs.sh

This script serves as a configuration and setup utility that:
1. Handles CPU-only mode flag
2. Sets up model download directories for popular AI libraries
3. Manages tutorial project installation
4. Prepares the environment for data science library installations

#### Key Operations

##### 1. CPU-Only Mode Configuration

- Accepts a `cpu_only` parameter as the first argument
- If set to "true", creates a `.cpu-only` marker file in `$WORDSLAB_WORKSPACE`
- This flag is used by other scripts to determine whether to install GPU-optimized versions of libraries

##### 2. Model Download Directory Setup

- Creates the `$WORDSLAB_MODELS` directory if it doesn't exist
- Configures environment variables in `_wordslab-notebooks-env.bashrc` for popular AI libraries to store their models and datasets in the designated models directory:
  - Hugging Face: `HF_HOME` → `$WORDSLAB_MODELS/huggingface`
  - FastAI: `FASTAI_HOME` → `$WORDSLAB_MODELS/fastai`
  - PyTorch: `TORCH_HOME` → `$WORDSLAB_MODELS/torch`
  - Keras: `KERAS_HOME` → `$WORDSLAB_MODELS/keras`
  - TensorFlow Hub: `TFHUB_CACHE_DIR` → `$WORDSLAB_MODELS/tfhub_modules`
  - Ollama: `OLLAMA_MODELS` → `$WORDSLAB_MODELS/ollama`

##### 3. Tutorial Project Management

- Removes existing tutorial project if it already exists (`$WORDSLAB_WORKSPACE/wordslab-notebooks-tutorials`)
- Creates a new tutorial project by cloning the official WordsLab tutorials repository
- This ensures users always have the latest tutorial content when upgrading WordsLab versions

##### 4. Integration with Other Scripts

- The script sets up the environment so that `create-workspace-project` (called for the tutorials) will:
  - Copy a `pyproject.toml` file from `../projects/`
  - Install common data science libraries
  - Install PyTorch (with GPU or CPU version based on the CPU-only flag)
  - Install VLLM (GPU version)

#### Integration with Workspace Structure

The script works within the WordsLab ecosystem by:
- Using the established `$WORDSLAB_MODELS` and `$WORDSLAB_WORKSPACE` variables
- Leveraging the existing `_wordslab-notebooks-env.bashrc` for environment configuration
- Working with the `create-workspace-project` infrastructure to set up tutorial environments
- Supporting the broader installation workflow that includes library dependencies

### 2_5_datascience-pyproject.toml

This configuration file defines the Python package dependencies and installation requirements for WordsLab's data science environment. 

- Supports both CPU-only and GPU-accelerated environments
- Automatically selects the appropriate PyTorch variant based on system capabilities
- Provides VLLM only for GPU installations
- Uses specific version numbers for all packages to ensure reproducible environments

#### Key Operations

##### 1. Project Metadata

- Defines a generic project name and version
- Sets Python version requirement to 3.12.x (specifically targeting Python 3.12)

##### 2. Core Dependencies

- Jupyter dev tool: nbdev
- Data Analysis: pandas, scikit-learn
- Deep Learning: fastai
- Local LLMs: ollama
- Jupyter AI Integration: jupyter-ai-magics, langchain-ollama, langchain-openai


```toml
dependencies = [
    "pandas==2.3.2",
    "scikit-learn==1.7.2",
    "fastai==2.8.4",
    "nbdev==2.4.5",
    "ollama==0.6.0",
    "jupyter-ai-magics==2.31.6",
    "langchain-ollama==0.3.8",
    "langchain-openai==0.3.33"
]
```

##### 3. Optional Dependencies (CPU vs CUDA)

- CPU Version: CPU PyTorch libraries (torch, torchvision, torchaudio)
- CUDA Version: GPUPyTorch libraries plus VLLM (a high-performance LLM inference engine)

```toml
[project.optional-dependencies]
cpu = [
  "torch==2.8.0",
  "torchvision==0.23.0",
  "torchaudio==2.8.0"
]
cuda = [
  "torch==2.8.0",
  "torchvision==0.23.0",
  "torchaudio==2.8.0",
  "vllm==0.11.0"
]
```

##### 4. Development Dependencies

- Includes ipykernel for Jupyter notebook kernel support

```toml
[dependency-groups]
dev = [
    "ipykernel==6.30.1",
]
```

##### 5. CPU or GPU Dependencies Resolution

- Prevents installation of both CPU and CUDA versions simultaneously
- Ensures only one PyTorch variant is installed

```toml
[tool.uv]
conflicts = [
  [
    { extra = "cpu" },
    { extra = "cuda" },
  ],
]
[tool.uv.sources]
torch = [
  { index = "pytorch-cpu", extra = "cpu" },
  { index = "pytorch-cu128", extra = "cuda" },
]
```

- CPU Index: `https://download.pytorch.org/whl/cpu` for CPU-only installations
- CUDA Index: `https://download.pytorch.org/whl/cu128` for GPU installations

#### Integration with Installation Flow

- Works with the `install-datascience-libs.sh` script to determine which dependencies to install
- The script's `cpu_only` parameter controls whether CPU or CUDA dependencies are selected

This configuration file is used by the `create-workspace-project` function to:
1. Install the base data science libraries
2. Install the appropriate PyTorch variant (CPU or CUDA) based on the system
3. Install VLLM for GPU-accelerated LLM inference when available
4. Set up a consistent Python environment for data science projects

The file essentially defines the "recipe" for creating reproducible, well-configured Python data science environments that can be either CPU-only or GPU-accelerated, depending on the user's hardware capabilities.

### 3__install-vscode-server.sh

This script serves as a coordinator that:
1. Installs Visual Studio Code server - Runs the `3_1_install-vscode-server.sh` script to set up the VS Code server component
2. Installs Aider AI code assistant - Executes the `3_2_install-aider-ai-agent.sh` script to add an AI-powered coding assistant

#### Key Operations

- Parameter handling: Takes a `cpu_only` parameter (passed as `$1`) which likely influences whether to install CPU-only or GPU-enabled versions of tools
- Modular approach: Delegates specific installation tasks to separate, specialized scripts
- Development environment enhancement: Adds IDE and AI assistant tools to the WordsLab workspace

### 3_1_install-vscode-server.sh

This script installs Visual Studio Code server in a persistent directory and configures it with essential extensions for data science development.

The script relies on environment variables:
- `$VSCODE_DIR`: Directory where code-server is installed
- `$VSCODE_DATA`: Directory for code-server data and extensions

This installation enables developers to access a full-featured VS Code environment with Python support and AI assistance directly in the WordsLab workspace, enhancing the development experience for data science projects.

#### Key Operations

##### 1. Installs Visual Studio Code server

- Downloads and installs code-server version 4.104.2 using the official install script
- Installs in a standalone method to a specified `$VSCODE_DIR` directory
- Uses the `--prefix` parameter to define where code-server will be installed

##### 2. Creates persistent data directory

- Makes a `$VSCODE_DATA` directory for storing code-server state and configuration
- This ensures that VS Code server data persists across sessions

##### 3. Installs Python extension

- Installs the official Microsoft Python extension (version 2025.14.0)
- Places the extension in the configured extensions directory
- This provides Python language support, IntelliSense, debugging capabilities

##### 4. Installs Continue AI assistant:

- Installs the Continue AI code assistant extension (version 1.2.7)
- Uses a separate global directory (`$VSCODE_DATA/.continue`) for Continue's data
- This provides AI-powered coding assistance within VS Code

### 3_2_install-aider-ai-agent.sh

This script installs Aider, an AI pair programming tool that operates directly in the terminal.

Aider is an AI coding assistant that:
- Works directly in your terminal/command line
- Can help write, edit, and debug code
- Provides pair programming assistance
- Integrates with your existing codebase
- Supports multiple programming languages (particularly Python in this context)

#### Key Operations

- Installs Aider using uv tool manager: 
  - Uses `uv tool install` to install the `aider-chat` package
  - Installs version 0.86.1 of Aider
  - The `uv` tool manager is used for dependency resolution and installation

### 4__install-open-webui.sh

This script serves as a coordinator that installs a complete local AI/LLM ecosystem with three interconnected components:
- Local LLM inference capabilities
- Web-based chat interface for AI interaction
- Document processing capabilities

#### Key Operations

##### 1. Ollama (via `4_1_install-ollama.sh`)

- Installs Ollama, a platform for running local Large Language Models
- Enables running LLMs directly on your machine without cloud dependencies
- Provides a simple interface for managing and running various LLMs locally

##### 2. Open WebUI (via `4_2_install-open-webui.sh`)

- Installs Open WebUI, a web-based chat interface for interacting with LLMs
- Provides a user-friendly graphical interface for chatting with local models
- Supports multiple models and offers a multi-model chat experience
- Enables web-based access to your local LLM capabilities

##### 3. Docling (via `4_3_install-docling.sh`)

- Installs Docling, a document extraction tool
- Enables processing and extracting information from various document formats
- Likely integrates with the LLM ecosystem for document-based AI applications

### 4_1_install-ollama.sh

This script installs Ollama and sets up a complete local LLM ecosystem with automatic model selection based on system capabilities.

- Provides offline LLM capabilities
- Automatically optimizes for system resources
- Integrates with both Jupyter and VS Code environments
- Enables AI-assisted coding and chat functionality
- Supports both CPU and GPU configurations

#### Key Operations

##### 1. Ollama Installation

- Creates a persistent directory for Ollama using `$OLLAMA_DIR`
- Downloads the latest Ollama binary (version 0.12.4) for Linux AMD64 architecture
- Extracts the binary to the configured directory
- Adds Ollama to the system PATH by updating `_wordslab-notebooks-env.bashrc`

##### 2. Ollama Server Setup

- Starts the Ollama server in the background
- Waits for the server to become ready (checks localhost:11434)
- Configures appropriate models based on system resources

##### 3. Intelligent Model Selection

The script automatically chooses the best LLM based on available GPU memory:
- CPU-only mode: Uses smaller models (gemma3:1b, qwen3:1.7b, etc.)
- GPU mode: Selects larger models based on VRAM capacity:
  - 24GB+ VRAM: gemma3:27b, qwen3-coder:30b
  - 16GB VRAM: gemma3:12b, qwen3:14b  
  - 8GB VRAM: gemma3:4b, qwen3:4b

##### 4. Configuration and Model Download

- Saves selected model names as environment variables in `_wordslab-notebooks-env.bashrc`
- Downloads all selected default LLMs using `ollama pull`
- Stops the Ollama server process

##### 5. Integration with Development Tools

- Jupyter AI Extension: Configures Ollama models for use with Jupyter AI, setting up:
  - Chat model for conversation
  - Embedding model for vector operations
  - Completion model for code completion
- VS Code Continue Extension: Configures Ollama models for use with Continue.dev VS Code extension, providing:
  - Code completion capabilities
  - Chat functionality
  - Embedding support
  - Context providers for various development tasks

### 4_2_install-open-webui.sh

This script sets up Open WebUI with proper environment configuration, dependency management, and system integration for local AI/LLM development.

This script creates a complete Open WebUI installation that:
- Provides a web-based interface for LLM interaction
- Supports both CPU and GPU configurations through UV's dependency management
- Enables secure HTTPS access
- Integrates with the existing WordsLab environment variables and conventions
- Sets up proper data storage locations for models, functions, and tools
- Includes speech-to-text capabilities through Whisper model integration

#### Key Operations

##### 1. Directory Setup

- Creates the main Open WebUI data directory (`$OPENWEBUI_DATA`)
- Sets up subdirectories for functions and tools within the data directory

##### 2. Environment Configuration

- Creates a dedicated virtual environment directory (`$OPENWEBUI_ENV`)
- Copies a specialized `pyproject.toml` configuration file to the environment
- Uses `uv sync` to install dependencies with either CPU or CUDA extras based on system configuration

##### 3. Special Handling for UV Link Mode

- Implements a workaround for UV's symlink mode compatibility issues with Open WebUI
- Manually copies the Open WebUI package from UV cache to avoid duplicate CUDA libraries
- This ensures efficient disk usage while maintaining compatibility

##### 4. HTTPS Support Patch

- Modifies the Open WebUI server initialization file to support HTTPS secure access
- Adds SSL keyfile and certificate file parameters to the server configuration
- Enables secure HTTPS connections for the web interface

##### 5. Model Initialization

- Configures CUDA usage based on system capabilities
- Downloads and initializes a small Whisper model for speech-to-text functionality
- The script configures the faster_whisper model with "small" size for efficient processing

### 4_2_openwebui-pyproject.toml

This configuration file serves as the dependency management configuration for the Open WebUI installation, specifically designed to handle both CPU and GPU environments with proper conflict resolution.

#### Key Operations

##### 1. Project Metadata

- Name: "openwebui-env" - identifies the virtual environment
- Python Requirement: >=3.12,<3.13 - specifies Python version compatibility

##### 2. Dependencies

Core Dependency: "open-webui==0.6.31" - the main Open WebUI package

Defines separate dependency sets for different hardware configurations:
- CPU Extra: Installs `torch==2.8.0` for CPU-only environments
- CUDA Extra: Installs `torch==2.8.0` for GPU environments

### 4_3_install-docling.sh

This script sets up Docling with proper environment configuration, dependency management, and model initialization for document processing capabilities within the WordsLab ecosystem.

This script creates a complete Docling installation that:
- Provides document processing capabilities for extracting structured data from documents
- Supports both CPU and GPU configurations through UV's dependency management
- Integrates with the existing WordsLab environment variables and conventions
- Sets up proper data storage locations for documents and models
- Enables automated model downloading and initialization

The installation enables users to:
- Process complex documents with layout analysis
- Extract tables, code, formulas, and text from various document types
- Leverage OCR capabilities for image-based text extraction
- Work with both CPU and GPU configurations depending on system resources
- Integrate document processing capabilities into larger AI/ML workflows within the WordsLab environment

#### Key Operations

##### 1. Directory Setup

- Creates the main Docling data directory (`$DOCLING_DATA`) for storing processed documents
- Creates a separate models directory (`$DOCLING_MODELS`) for storing Docling's model files

##### 2. Environment Configuration

- Creates a dedicated virtual environment directory (`$DOCLING_ENV`) 
- Copies the `4_3_docling-pyproject.toml` configuration file to the environment
- Uses `uv sync` to install dependencies with either CPU or CUDA extras based on system configuration

##### 3. Dependency Management

- The script leverages UV's dependency management system with CPU/CUDA support
- Automatically selects the appropriate PyTorch versions based on the system's capabilities
- Uses the custom PyTorch indexes defined in the pyproject.toml configuration

##### 4. Model Initialization

- Activates the virtual environment
- Downloads and initializes specific Docling models using the `docling-tools models download` command
- The script downloads models for:
  - layout: Layout analysis for document structure
  - tableformer: Table detection and extraction
  - code_formula: Code and formula recognition
  - picture_classifier: Image classification
  - easyocr: OCR (Optical Character Recognition)

##### 5. Commented-Out Future Enhancements

The script includes commented-out code that references:
- Future support for granite-docling VLM (Vision-Language Model) integration
- Notes about compatibility issues with HF transformers as of September 28, 2025

### 4_3_docling-pyproject.toml

This configuration file serves as the dependency management configuration for the Docling installation, specifically designed to handle both CPU and GPU environments with proper conflict resolution for document processing tools.

#### Key Operations

##### 1. Project Metadata

- Name: "docling-env" - identifies the virtual environment
- Python Requirement: >=3.12,<3.13 - specifies Python version compatibility

##### 2. Core Dependencies

- vLLM==0.11.0: Pinning this version to avoid downloading it twice (performance optimization)
- docling==2.55.1: Pinning this version to ensure reproducibility and stable behavior
- docling-serve[ui]==1.6.0: Installing Docling Serve with UI components for document processing interface

##### 3. Optional Dependencies (CPU vs GPU)

Defines separate dependency sets for different hardware configurations:
- CPU Extra: Installs `torch==2.8.0` for CPU-only environments
- CUDA Extra: Installs `torch==2.8.0` for GPU environments


## Windows startup scripts

### start-wordslab-notebooks.bat

This Windows batch script serves as the main entry point for starting the WordsLab Notebooks environment, with support for both local Windows development and remote Linux deployment scenarios.

This script provides a unified interface for starting WordsLab Notebooks across different environments while handling the complexities of cross-platform deployment, SSL certificate management, and remote access configuration.

#### Key Operations

##### 1. Dual-Mode Operation

The script operates in two distinct modes:
- Local Windows mode: When run without arguments or with `--name` parameter
- Remote Linux mode: When run with server address and optional port as arguments

Execution Flow

1. Parameter parsing - Determines if running locally or remotely
2. Platform detection - Identifies deployment environment via SSH
3. Certificate preparation - Sets up SSL certificates if needed
4. Remote execution - Runs the main startup script either locally or on remote server
5. Cleanup - Proper script termination

##### 2. Local Windows Mode

When run locally on Windows:
- Mounts Linux virtual disks using `4_mount-linux-virtual-disks.bat`
- Checks for SSL certificate existence in the WSL environment
- If certificate exists, configures remote access to ports (8880-8888) using PowerShell scripts
- Executes the Linux startup script (`start-wordslab-notebooks.sh`) within the WSL environment using `wsl -d`

##### 3. Remote Linux Mode

When arguments are provided, the script:
- Connects to a remote Linux server via SSH
- Detects the platform type (WSL, Jarvislabs.ai, Runpod.io, Vast.ai)
- Sets appropriate home directory paths based on platform
- Handles SSL certificate preparation and transfer if needed
- Executes the Linux startup script (`start-wordslab-notebooks.sh`) remotely

#### Key Technical Details  (Local Windows Mode)

##### Remote Access Configuration

- For local Windows mode, sets up port forwarding for remote access
- Uses PowerShell with administrator privileges when needed
- Handles WSL IP address changes automatically

#### Key Technical Details  (Remote Linux Mode)

##### Platform Detection

- Automatically identifies the deployment platform using SSH connection to remote server
- Supports WSL, Jarvislabs.ai, Runpod.io, and Vast.ai platforms
- Sets appropriate environment variables (`WORDSLAB_HOME`) for each platform

##### Certificate Management

- Checks if SSL certificates already exist on the remote server
- Generates new certificate secrets when needed using `prepare-server-secrets.bat`
- Transfers certificate files to the remote server via SCP

##### Environment Management

- Properly handles relative paths and directory navigation
- Uses delayed variable expansion for dynamic environment handling
- Manages SSH connections with proper key authentication

### 6_allow-remote-access-to-vm-ports.ps1

This PowerShell script is designed to configure network access for the WordsLab Notebooks virtual machine, enabling remote access to the various services running within the WSL environment. It is called by `start-wordslab-notebooks.bat` when a SSL certificate is installed, making the notebooks environment accessible from external machines.

This script serves as the network access configuration tool in the WordsLab Notebooks ecosystem. It:

1. Enables Remote Access: Makes all WordsLab services accessible from external machines
2. Configures Port Forwarding: Sets up proper network routing between host and WSL
3. Secures Network: Properly configures firewall rules for secure access
4. Provides Access Instructions: Shows users exactly how to access the services remotely

#### Key Operations

1. Privilege Check: Ensures Administrator rights are available
2. IP Detection: Gets the WSL VM's internal IP address
3. Port Setup: Defines default ports and accepts additional ports
4. Port Forwarding: Creates port proxy rules for each port
5. Firewall Setup: Opens firewall ports for inbound access
6. URL Display: Shows the accessible URL for remote access

##### 1. Administrator Privilege Check

- Validates that the script is running with Administrator privileges
- This is required because the script needs to modify firewall rules and network port configurations
- If not running as Administrator, it displays an error message and exits

##### 2. WSL VM IP Address Detection

- Uses WSL to query the IP address of the virtual machine's network interface
- Specifically queries `eth0` interface for the IP address
- Extracts the IP address from the network configuration output
- The IP address is used to map external port requests to the correct internal WSL VM

##### 3. Port Configuration

- Defines a default set of ports that need to be exposed:
  - JupyterLab (8880)
  - VS Code Server (8881)
  - Open WebUI (8882)
  - 5 user-defined applications (8883-8887)
  - Dashboard (8888)
- Accepts additional ports as command-line arguments (extends the default ports)
- Configures port forwarding for each port to map external requests to internal WSL VM ports

##### 4. Network Port Forwarding

- Uses `netsh interface portproxy add v4tov4` to create port forwarding rules
- Maps external port requests (0.0.0.0) to the internal WSL VM IP address
- This allows external machines to connect to the services running in WSL

##### 5. Firewall Configuration

- Opens firewall ports for inbound traffic on all configured ports
- Creates a firewall rule named "wordslab-notebooks" to allow TCP traffic
- Uses `netsh advfirewall firewall add rule` to configure the firewall

##### 6. Remote Access URL Display

- Identifies the primary external IP address of the Windows machine
- Filters out local/loopback addresses (169.254.*, 172.*, 127.*)
- Displays a complete URL that remote users can access the dashboard


## Linux startup scripts

### start-wordslab-notebooks.sh

This is the main startup script for the WordsLab Notebooks environment, written in Bash for Linux/WSL systems. It serves as the entry point that orchestrates the complete startup sequence of the entire WordsLab ecosystem.

1. Environment Setup - Configure paths and variables
2. Platform Detection - Handle Runpod-specific requirements
3. Environment Loading - Load all required environment variables
4. System Check - Verify installation status and reinstall if needed
5. Service Orchestration - Launch all WordsLab services via the main orchestrator

- Supports customizable installation paths through environment variables (`WORDSLAB_HOME`, `WORDSLAB_WORKSPACE`, `WORDSLAB_MODELS`)
- Handles different deployment scenarios (local WSL, cloud platforms like Runpod)

#### Key Operations

##### 1. Environment Configuration

- Default Path Setting: Sets `WORDSLAB_HOME` to `/home` if not already defined
- Directory Navigation: Changes to the `linux` directory where all related scripts are located
- Runpod Environment Handling: Specifically addresses Runpod platform requirements by modifying `.bashrc` if needed

##### 2. Environment Variable Initialization

- Sources `_wordslab-notebooks-env.bashrc` to load all necessary environment variables
- This file contains platform-specific settings

##### 3. System Prerequisites Check

- Installation State Check: Verifies if the system has been properly installed by checking for `/.wordslab-installed` file
- Reinstallation Logic: If the installation marker file doesn't exist, runs `1__update-operating-system.sh` to reinstall OS packages and reconfigure the shell
- This ensures proper initialization even after container restarts or system resets

##### 4. Main Service Startup

- Primary Execution: Calls `5_start-wordslab-notebooks.sh` to initiate all services
- This represents the core orchestration script that manages the complete startup sequence

### 5_start-wordslab-notebooks.sh

This bash script serves as the main entry point for starting the complete WordsLab Notebooks ecosystem, managing service startup, environment configuration, and process lifecycle management.

#### Key Operations

##### 1. Docker Startup

- Checks if running inside a Docker container using `/.dockerenv` file detection
- Automatically starts Docker daemon if not already running and not in container
- Ensures proper container environment setup

##### 2. URL Environment Variable Export

- Uses Python script `5_export-wordslab-urls.py` to dynamically export application URLs
- Sets up URLs for:
  - JupyterLab
  - VS Code
  - Open WebUI
  - User applications (5 additional apps)
  - Dashboard
- Enables centralized URL management for all services

##### 3. Security Configuration Management

- Handles certificate-based HTTPS security setup
- Manages password authentication for services
- Configures secure parameters for:
  - VS Code server
  - JupyterLab server
  - Open WebUI server
- Reads secrets from `.secrets` directory:
  - Certificate file
  - Certificate key file
  - Password file
- Implements fallback to no authentication when certificates/passwords aren't available

##### 4. Service Startup Commands

###### Visual Studio Code Server

- Launches code-server with specified port binding
- Configures secure parameters based on certificate availability
- Uses Continue AI extensions and custom data directories

###### JupyterLab Server

- Activates the JupyterLab virtual environment
- Starts server with:
  - Public IP binding (0.0.0.0)
  - Custom port configuration
  - Security parameters for HTTPS
  - Root access and remote access enabled
  - Workspace root directory set to WordsLab workspace

###### Ollama Server

- Launches Ollama language model server with:
  - Host binding to 0.0.0.0
  - Custom context length and memory settings
  - Optimized attention and estimation parameters

###### Docling Server (Conditional)

- Starts Docling document extraction service when enabled via environment variable
- Configures connection parameters for Open WebUI integration
- Sets up OCR engine and language support

###### Open WebUI Server

- Activates Open WebUI virtual environment
- Configures CUDA usage based on `.cpu-only` flag
- Sets up environment variables for:
  - Authentication (disabled)
  - Model configurations
  - Data directory paths
  - Tool and function directories
  - RAG embedding engine settings
  - Whisper model for audio processing

###### WordsLab Dashboard

- Starts the WordsLab dashboard service
- Provides centralized monitoring and management interface

##### 5. Process Management and Cleanup

- Implements process ID tracking for all started services
- Sets up signal trapping for graceful shutdown
- Uses cleanup function to terminate all processes on interrupt
- Waits for all processes to complete

##### 6. User Interface and Output

- Provides clear startup messages with dashboard URL
- Displays the dashboard URL for user access
- Implements proper sleep delay to ensure services start properly

#### Key Technical Details

##### Environment Variable Handling

- Uses `$WORDSLAB_WORKSPACE` for project paths
- Manages virtual environment activation for each service
- Configures CUDA vs CPU settings based on `.cpu-only` flag
- Sets up proper library paths for GPU acceleration

##### Security and Authentication

- Supports HTTPS with certificate-based authentication
- Implements password-based authentication for JupyterLab and Visual Studio Code
- Configures secure service parameters based on available credentials

### 5_export-wordslab-urls.py

This script is called by the main startup script (`5_start-wordslab-notebooks.sh`) to:
1. Generate all necessary service URLs
2. Export them as environment variables
3. Make them available to all running services
4. Ensure consistent endpoint configuration across the entire WordsLab ecosystem

#### Key Operations

##### 1. Port Configuration

- Reads environment variables for all service ports:
  - JupyterLab, VS Code, Open WebUI, 5 user applications, and Dashboard
- Stores ports in a list for processing

##### 2. HTTPS Detection

- Checks if SSL certificates exist in the `.secrets` directory
- Sets URL scheme to `https://` if certificates are present, otherwise `http://`

##### 3. Platform-Specific URL Generation

The script handles different deployment platforms:

###### Windows Subsystem for Linux (WSL)

- Reads IP address from `.WORDSLAB_WINDOWS_IP` file
- Uses this IP with port numbers for all endpoints

###### Jarvislabs.ai

- Uses Jarvislabs client API to fetch machine endpoints
- Retrieves actual deployment URLs from the Jarvislabs platform

###### Runpod.io

- Constructs URLs using pod ID and port numbers
- Format: `{pod_id}-{port}.proxy.runpod.net`

###### Vast.ai

- Uses public IP address and port mappings
- Maps environment variables like `VAST_TCP_PORT_{port}` to actual ports

###### UnknownLinux (default)

- Automatically detects local IP address when HTTPS is enabled
- Uses localhost (`127.0.0.1`) when HTTPS is disabled

##### 4. Environment Variable Export

- Exports all generated URLs as environment variables:
  - `JUPYTERLAB_URL`
  - `VSCODE_URL`
  - `OPENWEBUI_URL`
  - `USER_APP1_URL` through `USER_APP5_URL`
  - `DASHBOARD_URL` (always HTTP for dashboard)

### 5_1_start-docling-documents-extraction.sh

This script is responsible for starting the Docling document extraction service within the WordsLab Notebooks environment.

This script is called conditionally by the main startup script (`5_start-wordslab-notebooks.sh`) when Docling extraction is enabled. 

- Relies on environment variables
- `$DOCLING_ENV` - Path to Docling environment
- `$DOCLING_MODELS` - Model storage directory
- `$DOCLING_DATA` - Data processing directory

#### Key Operations

##### 1. Parameter Handling

- Accepts an optional port parameter as the first argument
- Defaults to port `5001` if no port is specified
- This port is used for internal communication with Open WebUI or JupyterLab

##### 2. Environment Activation

- Activates the Docling virtual environment using:
  ```bash
  source $DOCLING_ENV/.venv/bin/activate
  ```
- This ensures the script runs with Docling's specific dependencies and Python environment

##### 3. Environment Variable Configuration

Sets up three key environment variables for Docling:
- `DOCLING_SERVE_ARTIFACTS_PATH=$DOCLING_MODELS` - Path for Docling artifacts
- `DOCLING_SERVE_SCRATCH_PATH=$DOCLING_DATA` - Path for temporary processing files
- `DOCLING_SERVE_ENABLE_UI=true` - Enables the Docling UI interface

##### 4. Service Execution

Launches the Docling server with:
- `UVICORN_PORT=${1:-5001}` - Uses provided port or defaults to 5001
- `docling-serve run` - Starts the actual Docling server process
- `&` - Runs the process in the background
- `exit $!` - Exits with the process ID of the background job

## Windows multi-machine setup scripts

### prepare-client-machine.bat

This script serves as the client preparation tool in the WordsLab Notebooks ecosystem. It establishes the local client environment with all necessary credentials and tools needed to:
- Deploy WordsLab Notebooks on remote servers
- Manage secure SSH connections
- Handle HTTPS certificates for local development
- Maintain consistent secret management across multiple client machines

The script essentially creates a "client workstation" that can then be used to deploy and manage WordsLab Notebooks environments on remote cloud servers.

- Generates secure ED25519 SSH keys for authentication
- Uses mkcert for local certificate authority installation

#### Key Operations

1. Detection: Checks if `prepare-server-secrets.bat` exists (determines installation context)
2. Installation: If needed, downloads and extracts the full repository
3. Directory Setup: Creates and configures secrets directory
4. Secret Generation: 
   - Generates SSH key pair
   - Downloads and installs mkcert
5. Archive Creation: Packages all client secrets into a tar file
6. Instructions: Provides detailed usage instructions for next steps

##### 1. Dual-Mode Operation

The script operates in two contexts:
- Context 1: When scripts are already installed locally - uses existing `prepare-server-secrets.bat`
- Context 2: When starting from scratch - downloads and installs the complete repository first

##### 2. Repository Installation (When Needed)

- Creates installation directory (`WORDSLAB_WINDOWS_HOME`, default: `C:\wordslab`)
- Downloads the WordsLab Notebooks repository from GitHub
- Supports both main branch and tagged releases via `WORDSLAB_VERSION` parameter
- Unzips and sets up the scripts directory

##### 3. Secrets Directory Setup

- Creates a dedicated secrets directory at `..\secrets` relative to the scripts
- Normalizes the secrets directory path for consistent usage

##### 4. Client Secrets Management

- Reuses existing secrets: If `rootCA.pem` exists, it reuses client secrets from `wordslab-client-secrets.tar`
- Generates new SSH key: Creates an ED25519 SSH key pair for secure communication
- Downloads mkcert: Automatically downloads and installs the mkcert certificate utility for local HTTPS

##### 5. Archive Creation

- Creates a tar archive (`wordslab-client-secrets.tar`) containing all client secrets
- This archive can be transferred to other client machines for consistent setup

### prepare-server-secrets.bat

This is a Windows batch script designed to prepare server-side secrets for a WordsLab Notebooks deployment. It's the second component in the client-server setup workflow, following `prepare-client-machine.bat`.

It generates all the necessary security credentials and configuration files for a specific remote server, including:
- SSL certificates for HTTPS encryption
- Access passwords for secure remote access
- A packaged archive ready for transfer to the target server

The resulting tar archive (`wordslab-server-[machine]-secrets.tar`) is then transferred to the target server machine and used by the `install-wordslab-notebooks.bat` (Remote Linux Mode) or `prepare-server-machine.bat` (Local Windows Mode) script to complete the deployment process. This creates a secure, properly configured WordsLab Notebooks environment on the remote server.

#### Key Operations

1. Validation: Ensures client preparation has been completed
2. Setup: Normalizes secrets directory path
3. Input: Gets machine address (from parameter or user prompt)
4. Address Processing: Determines if IP or DNS subdomain, formats accordingly
5. Certificate Generation: Creates SSL certificates using mkcert
6. Password Input: Gets and stores password for remote access
7. Archive Creation: Packages all server secrets into a secure tar file
8. Cleanup: Removes original certificate and password files
9. Output: Provides instructions for transferring secrets to the server

##### 1. Prerequisite Verification

- Validates that the client machine has been prepared first by checking:
  - Presence of `mkcert.exe` in the scripts directory
  - Presence of `rootCA-key.pem` in the secrets directory
- If prerequisites aren't met, it exits with an error, directing users to run `prepare-client-machine.bat` first

##### 2. Secrets Directory Normalization

- Sets up the proper secrets directory path (`..\secrets` relative to script location)
- Uses `pushd`/`popd` to normalize the path for consistent usage

##### 3. Machine Address Handling

- Accepts machine address as command-line parameter or prompts user input
- Automatically detects if the input is an IP address or DNS subdomain
- For IP addresses: uses directly
- For DNS subdomains: prepends `*.` for wildcard certificate generation

##### 4. SSL Certificate Generation

- Uses the previously installed mkcert utility to generate SSL certificates
- Creates certificates for:
  - The specific machine address (with wildcard for DNS subdomains)
  - localhost and 127.0.0.1 for local access
  - IPv6 localhost (::1)
- Stores certificates in the secrets directory with `certificate.pem` and `certificate-key.pem` names

##### 5. Password Management

- Prompts user for a password to secure access to the remote machine
- If no password provided, creates an empty password file (indicating no password protection)
- Stores the password in the secrets directory

##### 6. Archive Creation

- Creates a tar archive containing all server-specific secrets:
  - SSL certificate files (`certificate.pem`, `certificate-key.pem`)
  - Password file
- Archives are named with the machine identifier for clear identification
- Removes original certificate and password files after archiving for security

##### Usage Instructions Provided

The script outputs clear instructions for:
1. Transferring secrets to the target server machine
2. Referencing documentation for the complete deployment process
3. Using the generated archive for server installation

### prepare-server-machine.bat

It's the third component in the client-server setup workflow, bridging the gap between client preparation and actual server installation.

This script completes the client-server setup sequence:

On the client machine
1. `prepare-client-machine.bat` - Prepares the Windows client with SSH keys and certificates
2. `prepare-server-secrets.bat` - Generates server-specific secrets and creates a tar archive

On the server machine
3. `prepare-server-machine.bat` - Transfers secrets to WSL and configures the environment
4. `start-wordslab-notebooks.bat` - Starts the full WordsLab Notebooks environment

The script ensures that the WSL environment has all the necessary configuration and security credentials to properly host the WordsLab Notebooks services, making it a crucial bridge between the Windows client setup and the actual server deployment.

#### Key Operations

1. IP Detection: Uses PowerShell to find the Windows machine's primary IP address
2. WSL File Creation: Writes IP address to WSL environment for reference
3. Archive Verification: Checks if matching secrets archive exists in `..\secrets` directory
4. WSL Integration: If archive exists, copies and extracts secrets to WSL workspace
5. Error Handling: Provides clear error message if secrets archive is missing

##### 1. Windows IP Address Detection

- Uses PowerShell to identify the primary non-WSL, non-loopback IPv4 address of the Windows machine
- This IP address represents the Windows host that will be running WSL
- The script filters out WSL interfaces and loopback interfaces to ensure it gets the correct external IP

##### 2. WSL IP File Creation

- Writes the detected Windows IP address to a special file in the WSL environment
- The file is created at `/home/.WORDSLAB_WINDOWS_IP` within the WSL wordslab-notebooks distribution
- This allows the WSL environment to know the IP address of the Windows host for network configuration

##### 3. Secrets Archive Validation

- Checks if a corresponding secrets archive exists in the `..\secrets` directory
- The archive name is expected to match the pattern `wordslab-server-[IP]-secrets.tar` where `[IP]` is the detected Windows IP
- This ensures the script only proceeds when the correct secrets have been generated on the client machine

##### 4. WSL Environment Integration

- If the secrets archive exists, it transfers and extracts the secrets into the WSL workspace
- Uses `wsl -d wordslab-notebooks-workspace` to target the specific WSL distribution
- Creates the `.secrets` directory in the workspace and copies the tar archive
- Extracts the archive contents to make the secrets available to the WSL environment