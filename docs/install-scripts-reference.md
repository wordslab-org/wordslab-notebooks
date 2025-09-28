# Installation scripts documentation

Version: wordslab-notebooks **2025-09**

## Windows installation script details

# Analysis of install-wordslab-notebooks.bat

This batch script is a Windows-based installer for the WordsLab Notebooks environment that can install on both local Windows machines and remote Linux servers. Let me break down what it does in detail:

## Script Overview

The script serves as a main entry point that determines whether to install locally on Windows or remotely on a Linux server based on command-line arguments.

## Key Features and Functionality

### 1. **Command-Line Argument Parsing**
- **Local Windows Installation**: `install-wordslab-notebooks.bat --cpu(optional) --name <wsl distribution name>(optional)`
- **Remote Linux Installation**: `install-wordslab-notebooks.bat <server address> <server ssh port>(optional)`

### 2. **Environment Variable Setup**
- Sets default values for installation parameters:
  - `name=wordslab-notebooks` (WSL distribution name)
  - `cpu=true` (default to CPU-only installation)
  - `WORDSLAB_VERSION=2025-09` (default version tag)
  - Various Windows-specific paths for installation directories

### 3. **Remote Installation Mode (Linux Servers)**
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

### 4. **Local Windows Installation Mode**
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

## Key Technical Details

### **Platform Detection**
The script uses SSH to run platform detection commands on remote servers, identifying:
- Microsoft Windows Subsystem for Linux
- Jarvislabs.ai cloud platform
- Runpod.io cloud platform
- Vast.ai cloud platform

### **Version Management**
Supports both:
- `main` branch for latest development version
- Specific version tags (like `2025-09`) for stable releases

### **GPU Detection**
On Windows, the script checks for NVIDIA GPU availability and automatically sets CPU mode to false if a GPU is detected.

### **Security Considerations**
- Requires SSH keys in a dedicated `secrets` directory
- Uses `StrictHostKeyChecking=no` for automated SSH connections (security note)
- Validates required API keys for Jarvislabs.ai platform

## Installation Process Flow

1. **Local Mode**: 
   - Downloads repository
   - Installs WSL
   - Creates Linux VM
   - Creates and mounts virtual disks
   - Installs Linux environment

2. **Remote Mode**:
   - Validates SSH access
   - Detects platform
   - Sets up platform-specific paths
   - Executes installation script on remote server via curl

This script provides a unified interface for installing the WordsLab Notebooks environment across different platforms while handling the complexity of cross-platform installation requirements.

# # Analysis of `install-wordslab-notebooks.sh`

This is the main installation script for the WordsLab Notebooks environment. It's a comprehensive setup script that downloads, configures, and installs the complete WordsLab ecosystem with all its components.

## Key Functions

### 1. **Environment Configuration**
- Sets default values for `WORDSLAB_HOME` (default: `/home`) and `WORDSLAB_VERSION` (default: `2025-09`)
- Supports customization through environment variables for installation paths
- Prepares the installation directory structure

### 2. **Source Code Acquisition**
- Downloads the WordsLab Notebooks repository from GitHub
- Supports both main branch and tagged releases via `WORDSLAB_VERSION` parameter
- Unzips the downloaded archive and cleans up temporary files

### 3. **Environment Variable Management**
- Backs up the existing `_wordslab-notebooks-env.bashrc` file
- Iterates through current environment variables to find WORDSLAB-specific variables
- Updates the bashrc file with current environment settings
- Sources the updated environment variables for immediate use

### 4. **System Prerequisites Installation**
- Updates Ubuntu package lists and installs essential packages (curl, unzip)
- Runs `1__update-operating-system.sh` to install necessary system packages
- Installs Python environment and data science libraries via `2__install-wordslab-notebooks.sh`

### 5. **Component Installation**
Sequentially installs all major components:
- **Notebooks Environment**: Python, JupyterLab, dashboard, data science libraries
- **Code Environment**: VS Code server, Aider AI agent
- **Chat/LLM Environment**: Open WebUI, Ollama

### 6. **Shell Configuration**
- Configures the shell environment for new sessions
- Sets up proper directory navigation and environment activation
- Updates `.bashrc` to ensure new shells start in the correct environment

### 7. **Startup Script Generation**
- Creates a convenient startup script at `$WORDSLAB_HOME/start-wordslab-notebooks.sh`
- Sets proper environment variables and directory paths
- Makes the script executable

## Execution Flow

1. **Initialization** - Set default paths and download repository
2. **Environment Setup** - Configure variables and install system packages
3. **Component Installation** - Install all required software components
4. **Shell Configuration** - Set up environment for new sessions
5. **Finalization** - Create startup script with usage instructions

## Key Features

### Flexibility
- Supports custom installation paths via environment variables
- Supports both main branch and tagged releases
- Handles Windows WSL environments with special path handling

### Automation
- Fully automated installation process
- Self-contained - handles all dependencies and setup
- Idempotent - can be run multiple times safely

### Cross-Platform Support
- Special handling for Windows Subsystem for Linux (WSL)
- Provides appropriate startup commands for different environments

### Comprehensive Setup
- Installs complete AI/ML development environment
- Includes JupyterLab, VS Code server, Open WebUI, Ollama
- Sets up data science libraries and tools

This script serves as the complete installation solution for the WordsLab Notebooks ecosystem, transforming a fresh system into a fully-featured AI development environment with all necessary tools and services pre-configured.

# Analysis of 1_install-or-update-windows-subsystem-for-linux.bat

This is a simple batch script that serves as a wrapper for a PowerShell script to install or update Windows Subsystem for Linux (WSL). Let me break down what it does:

## Script Functionality

### **Primary Purpose**
- This script acts as a bridge between the batch environment and PowerShell to install or update WSL components on Windows

### **Key Operations**
1. **PowerShell Execution**:
   - Calls `PowerShell -ExecutionPolicy Bypass -File .\1_install-or-update-windows-subsystem-for-linux.ps1`
   - Uses `-ExecutionPolicy Bypass` to allow execution of the PowerShell script without requiring elevated permissions or changing system-wide execution policies
   - Executes the PowerShell script located in the same directory

2. **Error Handling**:
   - Checks the exit code (`%ERRORLEVEL%`) from the PowerShell script
   - If the PowerShell script fails (non-zero exit code), it exits the batch script with the same error code

## Why This Approach?

### **Why Not Direct PowerShell?**
- The batch script is the entry point for the Windows installation flow
- It provides a consistent interface for the installation process
- It allows for proper error propagation back to the calling installation sequence

### **Execution Policy Bypass**
- The `-ExecutionPolicy Bypass` flag is necessary because:
  - PowerShell scripts often require elevated execution policies
  - This approach avoids requiring administrator privileges
  - It allows the script to run without modifying system-wide security settings

## Expected Behavior

When executed, this script:
1. Launches PowerShell with the appropriate execution policy
2. Runs the PowerShell installation script that handles:
   - Installing WSL if not present
   - Updating WSL to the latest version if already installed
   - Installing the WSL2 kernel update package if needed
   - Ensuring all WSL components are properly configured

## Integration with Installation Flow

This script is the first step in the Windows installation sequence:
1. `1_install-or-update-windows-subsystem-for-linux.bat` - Ensures WSL is available
2. `2_create-linux-virtual-machine.bat` - Creates the Linux VM
3. `3_create-linux-virtual-disks.bat` - Creates virtual disks
4. `4_mount-linux-virtual-disks.bat` - Mounts virtual disks
5. `5_install-linux-virtual-machine.bat` - Installs the full Linux environment

The batch wrapper ensures that the PowerShell-based WSL installation is properly executed as part of the larger installation workflow.

# Analysis of 2_create-linux-virtual-machine.bat

This batch script creates a Linux virtual machine using Windows Subsystem for Linux (WSL) by importing an Ubuntu Linux distribution. Let me break down its functionality:

## Script Purpose
Creates a WSL distribution (Linux virtual machine) that will serve as the runtime environment for WordsLab Notebooks.

## Key Operations

### **1. Parameter Validation**
- Requires the WSL distribution name as a command-line argument (`%1`)
- This name is used to identify the specific WSL instance (e.g., "wordslab-notebooks")

### **2. Check if VM Already Exists**
- Uses `wsl -d %1 -- : >nul` to test if the distribution already exists
- If the command fails (errorlevel ≠ 0), it means the VM doesn't exist and needs to be created

### **3. VM Creation Process**
When VM doesn't exist:
- **Creates directory structure**: `mkdir %WORDSLAB_WINDOWS_HOME%\virtual-machines\%1`
- **Downloads Ubuntu base image**: 
  - Downloads `ubuntu-noble.tar` from Canonical's partner images repository
  - Uses Ubuntu Noble (24.04 LTS) as the base Linux distribution
- **Imports the VM**: 
  - Uses `wsl --import` command to create the WSL distribution
  - Imports the downloaded tar.gz image into the specified directory
- **Cleanup**: Deletes the downloaded tar file after import

### **4. Initial Configuration**
- **Runs a setup command**: `wsl -d %1 -- sh -c "echo '%WORDSLAB_WINDOWS_HOME%\\\\virtual-machines\wordslab-notebooks' > /home/.WORDSLAB_WINDOWS_HOME"`
- **Creates a configuration file**: Writes the Windows home directory path to `/home/.WORDSLAB_WINDOWS_HOME` inside the Linux VM
- **Purpose**: This file serves as a reference point for the Windows installation path, allowing the Linux environment to know where Windows files are located

## Technical Details

### **WSL Import Process**
- Uses `wsl --import` which is the standard WSL command for creating new distributions
- The import process creates a complete Linux filesystem from the tarball
- The VM is stored in the Windows directory structure under `%WORDSLAB_WINDOWS_HOME%\virtual-machines\%1`

### **Ubuntu Noble Base Image**
- Downloads Ubuntu 24.04 LTS (Noble) from Canonical's official partner images
- This provides a modern, stable Linux environment for the notebooks
- Uses the OCI (Open Container Initiative) format for the base image

### **Path Handling**
- Properly escapes Windows paths with double backslashes (`\\\\`) for use in Linux context
- Creates a reference file that allows Linux processes to access Windows paths

## Integration in Installation Flow

This script is the second step in the Windows installation sequence:
1. `1_install-or-update-windows-subsystem-for-linux.bat` - Ensures WSL is available
2. `2_create-linux-virtual-machine.bat` - Creates the Linux VM (this script)
3. `3_create-linux-virtual-disks.bat` - Creates virtual disks
4. `4_mount-linux-virtual-disks.bat` - Mounts virtual disks
5. `5_install-linux-virtual-machine.bat` - Installs the full Linux environment

## Error Handling
- The script relies on the error checking in the initial `wsl -d %1 -- : >nul` command
- If the VM already exists, it skips creation (no duplicate creation)
- If the import fails, it will propagate the error to the calling installation sequence

This script essentially establishes the Linux foundation that will host the WordsLab Notebooks environment, providing a complete Ubuntu Linux system within Windows via WSL.

# Analysis of 3_create-linux-virtual-disks.bat

This batch script creates two separate Linux virtual disks using WSL for storing workspace and models data. Let me break down its functionality:

## Script Purpose
Creates two distinct WSL distributions to serve as virtual disks for storing WordsLab Notebooks workspace data and model data separately.

## Key Operations

### **1. Parameter and Environment Validation**
- **No command-line parameters** required
- **Requires two environment variables**:
  - `%WORDSLAB_WINDOWS_WORKSPACE%`: Directory for workspace virtual disk
  - `%WORDSLAB_WINDOWS_MODELS%`: Directory for models virtual disk

### **2. Check if Virtual Disks Already Exist**
- Uses `wsl -d wordslab-notebooks-workspace -- : >nul` to test if workspace VM already exists
- If the command fails (errorlevel ≠ 0), it means the VMs don't exist and need to be created

### **3. Virtual Disk Creation Process**
When VMs don't exist:
- **Downloads Alpine Linux base image**:
  - Downloads `alpine.tar` from Alpine Linux CDN (version 3.22)
  - Uses Alpine Linux (minimal Linux distribution) for lightweight virtual disks
- **Creates workspace disk**:
  - Creates directory: `mkdir %WORDSLAB_WINDOWS_WORKSPACE%`
  - Imports Alpine image as WSL distribution: `wsl --import wordslab-notebooks-workspace %WORDSLAB_WINDOWS_WORKSPACE% alpine.tar`
- **Creates models disk**:
  - Creates directory: `mkdir %WORDSLAB_WINDOWS_MODELS%`
  - Imports Alpine image as WSL distribution: `wsl --import wordslab-notebooks-models %WORDSLAB_WINDOWS_MODELS% alpine.tar`
- **Cleanup**: Deletes the downloaded tar file after both imports

### **4. Directory Setup in Linux Environments**
- **Creates mount points**:
  - `wsl -d wordslab-notebooks-workspace -- mkdir -p /home/workspace`
  - `wsl -d wordslab-notebooks-models -- mkdir -p /home/models`
- **Creates configuration files**:
  - `wsl -d wordslab-notebooks-workspace -- sh -c "echo '%WORDSLAB_WINDOWS_WORKSPACE%' > /home/workspace/.WORDSLAB_WINDOWS_WORKSPACE"`
  - `wsl -d wordslab-notebooks-models -- sh -c "echo '%WORDSLAB_WINDOWS_MODELS%' > /home/models/.WORDSLAB_WINDOWS_MODELS"`

## Technical Details

### **Alpine Linux Base**
- Uses Alpine Linux (minimal Linux distribution) for virtual disks
- Much smaller than Ubuntu, making it more efficient for data storage
- `alpine-minirootfs-3.22.1-x86_64.tar.gz` provides a minimal root filesystem

### **Separate Storage Volumes**
- **Workspace disk**: Dedicated storage for notebooks, code, and user data
- **Models disk**: Dedicated storage for large model files and datasets
- This separation allows for better organization and potentially different storage strategies

### **Path Reference Files**
- Creates `.WORDSLAB_WINDOWS_WORKSPACE` and `.WORDSLAB_WINDOWS_MODELS` files in each disk
- These files contain the Windows host paths for the respective disks
- Allows Linux environments to reference and access the Windows host directories

## Integration in Installation Flow

This script is the third step in the Windows installation sequence:
1. `1_install-or-update-windows-subsystem-for-linux.bat` - Ensures WSL is available
2. `2_create-linux-virtual-machine.bat` - Creates the main Linux VM
3. `3_create-linux-virtual-disks.bat` - Creates separate virtual disks (this script)
4. `4_mount-linux-virtual-disks.bat` - Mounts the virtual disks
5. `5_install-linux-virtual-machine.bat` - Installs the full Linux environment

## Error Handling
- Checks if virtual disks already exist to prevent duplicate creation
- Relies on error checking from the initial WSL command
- If either disk creation fails, it will propagate the error to the calling installation sequence

## Purpose in Overall Architecture
This script establishes separate storage volumes for:
- **Workspace data**: Notebooks, scripts, and user-created content
- **Models data**: Large machine learning models and datasets
- This separation provides better organization, potential for different storage strategies, and cleaner data management

The virtual disks are created as separate WSL distributions, allowing them to be mounted and accessed as distinct storage volumes within the larger WordsLab environment.

# Analysis of 4_mount-linux-virtual-disks.bat

This batch script establishes bidirectional mounting between the WSL virtual disks and the main WordsLab Notebooks WSL distribution. Let me break down its functionality:

## Script Purpose
Creates a mounting system that allows the main WordsLab Notebooks WSL distribution to access data stored in the separate workspace and models virtual disks.

## Key Operations

### **1. Parameter Handling**
- Takes a WSL distribution name as a command-line parameter (`%name%`)
- This parameter likely refers to the main WordsLab Notebooks distribution (e.g., "wordslab-notebooks")

### **2. Mounting Process for Workspace Disk**
For the workspace virtual disk:
- **Creates mount point in workspace VM**: `wsl -d wordslab-notebooks-workspace -- mkdir -p /mnt/wsl/wordslab-notebooks-workspace`
- **Binds workspace directory**: `wsl -d wordslab-notebooks-workspace -- mount --bind /home/workspace /mnt/wsl/wordslab-notebooks-workspace`
- **Creates mount point in main VM**: `wsl -d %name% -- mkdir -p /home/workspace`
- **Binds mount point**: `wsl -d %name% -- mount --bind /mnt/wsl/wordslab-notebooks-workspace /home/workspace`

### **3. Mounting Process for Models Disk**
For the models virtual disk:
- **Creates mount point in models VM**: `wsl -d wordslab-notebooks-models -- mkdir -p /mnt/wsl/wordslab-notebooks-models`
- **Binds models directory**: `wsl -d wordslab-notebooks-models -- mount --bind /home/models /mnt/wsl/wordslab-notebooks-models`
- **Creates mount point in main VM**: `wsl -d %name% -- mkdir -p /home/models`
- **Binds mount point**: `wsl -d %name% -- mount --bind /mnt/wsl/wordslab-notebooks-models /home/models`

## Technical Details

### **Bind Mounting**
- Uses `mount --bind` to create bind mounts
- This creates a "mirror" of directories so that changes in one location are reflected in the other
- Allows the main WSL distribution to access data from the separate workspace and models disks

### **Directory Structure**
- **Workspace disk**: `/home/workspace` (in workspace VM) → `/mnt/wsl/wordslab-notebooks-workspace` → `/home/workspace` (in main VM)
- **Models disk**: `/home/models` (in models VM) → `/mnt/wsl/wordslab-notebooks-models` → `/home/models` (in main VM)

### **Mount Point Organization**
- Creates intermediate mount points in the virtual disks (`/mnt/wsl/...`)
- Creates final mount points in the main WSL distribution (`/home/...`)
- This two-level approach allows proper separation while enabling access

## Integration in Installation Flow

This script is the fourth step in the Windows installation sequence:
1. `1_install-or-update-windows-subsystem-for-linux.bat` - Ensures WSL is available
2. `2_create-linux-virtual-machine.bat` - Creates the main Linux VM
3. `3_create-linux-virtual-disks.bat` - Creates separate virtual disks
4. `4_mount-linux-virtual-disks.bat` - Mounts the virtual disks (this script)
5. `5_install-linux-virtual-machine.bat` - Installs the full Linux environment

## Purpose in Overall Architecture

### **Data Access Layer**
- Enables the main WordsLab Notebooks environment to access:
  - Workspace data (notebooks, code, user files)
  - Models data (large ML models, datasets)
- Provides a clean separation of concerns while maintaining accessibility

### **Storage Organization**
- **Workspace disk**: Contains user workspace files (notebooks, scripts, etc.)
- **Models disk**: Contains large model files and datasets
- **Main VM**: Contains the core WordsLab environment with access to both storage areas

### **Cross-VM Data Access**
- The main WSL distribution can now access both workspace and models data
- Data remains physically separated in different virtual disks for organization and potential different storage strategies
- The mounting system provides transparent access to all data from the main environment

## Error Handling
- The script assumes that all previous steps (WSL installation, VM creation, disk creation) have already been completed successfully
- If any WSL distribution doesn't exist or directories don't exist, the mount commands will fail
- No explicit error checking is included in the script

This mounting process is crucial for creating a unified access point for the WordsLab Notebooks environment while maintaining the organizational benefits of separate storage volumes.

# Analysis of 5_install-linux-virtual-machine.bat

This batch script performs the final installation step in the WordsLab Notebooks Windows setup process, executing the main Linux installation script within the specified WSL distribution.

## Script Purpose
Completes the WordsLab Notebooks installation by running the main installation script (`install-wordslab-notebooks.sh`) within the specified WSL distribution, setting up the complete Linux environment.

## Key Operations

### **1. Parameter Handling**
- **Required parameters**:
  - `%1`: WSL distribution name (e.g., "wordslab-notebooks")
  - `%2`: CPU-only flag (likely "true" or "false" to determine if CUDA support should be installed)
- Uses `%1` as the target WSL distribution for installation

### **2. Directory Management**
- **Saves current directory**: `set "originalDir=%cd%"`
- **Changes to parent directory**: `cd ..`
- **Returns to original directory**: `cd "%originalDir%"` (after installation completes)

### **3. Main Installation Execution**
- **Command**: `wsl -d %1 -- WORDSLAB_VERSION=%WORDSLAB_VERSION% ./install-wordslab-notebooks.sh %2`
- Executes the `install-wordslab-notebooks.sh` script within the specified WSL distribution
- **Environment variable**: Sets `WORDSLAB_VERSION=%WORDSLAB_VERSION%` for the installation
- **Script parameter**: Passes `%2` (CPU-only flag) to the installation script

## Technical Details

### **WSL Command Structure**
- `wsl -d %1 --` - Executes command in specified WSL distribution
- `WORDSLAB_VERSION=%WORDSLAB_VERSION%` - Sets environment variable in the WSL context
- `./install-wordslab-notebooks.sh %2` - Runs the main installation script with CPU-only parameter

### **Installation Context**
- **Working Directory**: Changes to parent directory before execution, then returns
- **Environment**: Inherits the WSL distribution's environment but sets the specific version variable
- **Parameters**: Passes CPU-only flag to control CUDA/nvidia support installation

## Integration in Installation Flow

This script is the final step in the Windows installation sequence:
1. `1_install-or-update-windows-subsystem-for-linux.bat` - Ensures WSL is available
2. `2_create-linux-virtual-machine.bat` - Creates the main Linux VM
3. `3_create-linux-virtual-disks.bat` - Creates separate virtual disks
4. `4_mount-linux-virtual-disks.bat` - Mounts the virtual disks
5. `5_install-linux-virtual-disks.bat` - Installs the full Linux environment (this script)

## Purpose in Overall Architecture

### **Final Environment Setup**
- Completes the installation of the WordsLab Notebooks environment
- Installs all necessary packages, dependencies, and configurations
- Sets up the complete Linux environment with the appropriate compute capabilities

### **Flexible Installation Options**
- **CPU-only mode**: When `%2` is set to "true", installs without CUDA support
- **Full GPU mode**: When `%2` is set to "false", installs with CUDA support for GPU acceleration
- This allows users to choose their compute requirements based on their hardware

### **Version Management**
- Uses the `WORDSLAB_VERSION` environment variable to ensure consistent version installation
- Maintains version consistency across the entire installation process

## Important Notes

### **Mounting Constraint**
- The script includes a comment noting that `WORDSLAB_WORKSPACE` or `WORDSLAB_MODELS` default paths **cannot** be changed in the WSL virtual machine
- This is crucial because changing these paths would break the mounting system established in step 4 (`4_mount-linux-virtual-disks.bat`)
- This constraint ensures that the mounting system continues to work properly

### **Directory Navigation**
- Changes to parent directory during execution to ensure the installation script can be found
- Returns to original directory after installation completes
- This is a standard pattern for scripts that need to execute from a different working directory

## Expected Outcome
This script completes the full WordsLab Notebooks installation by:
1. Setting up the Linux environment in the specified WSL distribution
2. Installing all required packages and dependencies
3. Configuring the environment with the appropriate compute capabilities
4. Making the WordsLab Notebooks ready for use with the established storage system

The installation process is now complete, and users should be able to access WordsLab Notebooks through the configured WSL environment.

# Analysis of linux/1__update-operating-system.sh

This bash script serves as the main entry point for updating and configuring the Linux operating system environment in the WordsLab Notebooks setup. Let me break down its functionality:

## Script Purpose
Updates and configures the Linux operating system environment, installing necessary packages and setting up containerization capabilities for the WordsLab Notebooks environment.

## Key Operations

### **1. Parameter Handling**
- **Input parameter**: `cpu_only=$1` - Determines whether to install CPU-only or GPU-enabled configurations
- If `cpu_only` is set to "true", installs only CPU capabilities
- If `cpu_only` is set to "false" or any other value, installs GPU capabilities with NVIDIA support

### **2. Package Installation**
- **Calls**: `./1_1_install-ubuntu-packages.sh`
- Installs all required Ubuntu/Debian packages needed for WordsLab Notebooks
- This is a prerequisite step for the entire environment

### **3. Docker Installation**
- **Conditional execution**: Only installs Docker if NOT inside a Docker container (`[ ! -f /.dockerenv ]`)
- **Docker setup**: `./1_2_install-docker.sh`
- **NVIDIA runtime**: Only installs NVIDIA container runtime when GPU support is requested (`! "$cpu_only" == "true"`)

### **4. Installation Tracking**
- **Creates marker file**: `touch /.wordslab-installed`
- This prevents the script from running multiple times unnecessarily
- Acts as a flag to remember that the operating system was already updated

## Technical Details

### **Docker Environment Detection**
- Uses `/.dockerenv` file check to detect if running inside a Docker container
- This prevents Docker installation within Docker containers (which would cause conflicts)
- Standard approach for detecting container environments

### **GPU Support Conditional Installation**
- **CPU-only mode**: When `cpu_only=true`, only installs basic packages and Docker
- **GPU mode**: When `cpu_only=false`, installs NVIDIA container runtime for GPU acceleration
- Allows flexible deployment based on user's hardware capabilities

### **Idempotent Operation**
- The `touch /.wordslab-installed` creates a marker file to prevent re-execution
- This ensures the OS update process doesn't run multiple times
- Prevents redundant package installations and potential conflicts

## Integration in Linux Installation Flow

This script is part of the broader Linux installation process:
1. `1__update-operating-system.sh` - Main OS update and configuration
2. `2__install-python-environment.sh` - Python environment setup
3. `3__install-words-lab-notebooks.sh` - WordsLab Notebooks installation
4. `4__install-words-lab-models.sh` - Model installation

## Purpose in Overall Architecture

### **System Foundation**
- Establishes the base operating system configuration
- Installs all essential packages and dependencies
- Sets up containerization infrastructure for the WordsLab environment

### **Flexible Deployment Support**
- **CPU-only support**: For systems without GPU or when GPU support isn't needed
- **GPU support**: For systems with NVIDIA GPUs that can leverage CUDA acceleration
- Enables deployment across different hardware configurations

### **Containerization Ready**
- Prepares the environment for Docker-based execution
- Sets up NVIDIA container runtime for GPU-accelerated Docker containers
- Creates foundation for running machine learning workloads in containers

## Important Considerations

### **Reset Prevention**
- Includes a note: "NB: you need to re-execute this script each time the container image is reset"
- Indicates that if the container image is reset or rebuilt, this script must be re-run
- This is important for containerized environments where images might be recreated

### **Execution Context**
- Designed to be run in a WSL or Linux environment
- Assumes it's being executed as part of a larger installation sequence
- Relies on other scripts in the directory for specific installations

## Expected Outcome
This script prepares the Linux environment by:
1. Installing essential system packages
2. Setting up Docker containerization capabilities
3. Configuring GPU support when requested
4. Creating installation markers to prevent duplicate runs
5. Establishing a solid foundation for the subsequent WordsLab Notebooks installation steps

The script ensures that the Linux environment is properly configured to support both CPU-only and GPU-accelerated execution of WordsLab Notebooks workloads.


# This is the `linux/1_1_install-ubuntu-packages.sh` script that installs essential Ubuntu packages for the WordsLab Notebooks environment. Here's what it does:

## Script Overview
This script installs a comprehensive set of command-line tools and utilities that are fundamental for development, system administration, and data processing workflows.

## Key Components

### 1. **System Configuration**
- Sets `DEBIAN_FRONTEND=noninteractive` to prevent interactive prompts during installation
- Configures locale settings (`en_US.UTF-8`) for proper text encoding

### 2. **Essential Utilities**
- **Basic system tools**: `sudo`, `apt-utils`, `locales` - core system components
- **Text editors**: `less`, `vim`, `tmux`, `screen` - for file editing and terminal management
- **Network tools**: `ca-certificates`, `curl`, `wget`, `unzip`, `openssh-client` - for downloading and network operations
- **Monitoring tools**: `htop`, `nvtop`, `iputils-ping`, `net-tools`, `traceroute` - for system monitoring and network diagnostics

### 3. **Development Tools**
- **Version control**: `git`, `git-lfs` - for source code management
- **Build tools**: `build-essential`, `cmake` - for compiling software
- **Media processing**: `ffmpeg` - for audio/video processing

### 4. **Optional Documentation Tools**
- Contains commented-out lines for installing `pandoc` and LaTeX packages that would enable PDF/HTML notebook generation

## Purpose
This script establishes the foundational software environment needed for the WordsLab Notebooks platform, providing developers with essential tools for coding, system administration, network troubleshooting, and multimedia processing - all while maintaining a minimal, efficient installation that supports the subsequent Python environment and notebook workflows.

# This is the `linux/1_2_install-docker.sh` script that installs Docker Engine on Ubuntu. Here's what it does:

## Script Overview
This script installs Docker Engine and related components on Ubuntu systems, enabling containerization capabilities for the WordsLab Notebooks environment.

## Key Components

### 1. **GPG Key Setup**
- Checks if Docker's official GPG key already exists at `/etc/apt/keyrings/docker.asc`
- If the key doesn't exist, it:
  - Creates the `/etc/apt/keyrings` directory with proper permissions
  - Downloads Docker's official GPG key from `https://download.docker.com/linux/ubuntu/gpg`
  - Sets appropriate read permissions on the key file

### 2. **Repository Configuration**
- Adds Docker's official repository to the APT sources list
- Uses the system's version codename to ensure compatibility
- Configures the repository with the correct architecture and signing key

### 3. **Docker Installation**
- Updates the package index
- Installs the following Docker components:
  - `docker-ce` - Docker Engine (core container engine)
  - `docker-ce-cli` - Docker Command Line Interface
  - `containerd.io` - Container runtime
  - `docker-buildx-plugin` - Enhanced build capabilities
  - `docker-compose-plugin` - Docker Compose functionality

## Purpose
This script establishes the containerization infrastructure needed for the WordsLab Notebooks platform. Docker enables:
- Isolated development environments
- Consistent deployment across different systems
- Efficient resource utilization
- Container-based workflows for machine learning and data processing tasks

The installation is designed to be idempotent and follows Docker's official installation guidelines for Ubuntu systems.

# This is the `linux/1_3_configure-shell-environment.sh` script that configures the shell environment for WordsLab Notebooks. Here's what it does:

## Script Overview
This script sets up the shell environment by modifying `.bashrc` to load WordsLab-specific configurations and creates a marker file to track installation status.

## Key Components

### 1. **Environment Configuration**
- Appends sourcing commands to `~/.bashrc` to load two specific configuration files:
  - `_wordslab-notebooks-env.bashrc` - Sets environment variables for storage paths and ports
  - `_wordslab-notebooks-init.bashrc` - Initializes the shell with proper Python environment and working directory

### 2. **Installation Tracking**
- Creates a marker file `~/.wordslab-installed` containing the current `WORDSLAB_VERSION`
- This flag distinguishes between first-time installations and subsequent updates

### 3. **Important Notes**
- Includes a warning that this script should only be run after:
  - `2__install-wordslab-notebooks.sh` (installs WordsLab Notebooks)
  - `3__install-open-webui.sh` (installs Open WebUI)
- Mentions that commands accumulate in `.bashrc` with newer versions overwriting older ones
- The script is designed to be run as part of the installation sequence

## Purpose
This script ensures that:
- Users have access to WordsLab-specific environment variables and aliases
- The correct Python environment is activated automatically
- The proper working directory is set
- Installation version tracking is maintained for update purposes
- Shell configuration persists across sessions

The script essentially "glues" the WordsLab environment into the user's shell session, making the installed tools and configurations immediately available.

# This is the `2__install-wordslab-notebooks.sh` script that installs the core WordsLab Notebooks environment. Here's what it does:

## Script Overview
This is the main installation script that sets up the WordsLab Notebooks Python environment, JupyterLab, and data science libraries. It orchestrates multiple sub-scripts to build a complete development environment.

## Key Components

### 1. **Python Environment Setup**
- Calls `2_1_install-python-environment.sh` to install and configure a Python environment manager (likely conda/Miniconda)
- Sources the UV installation to add it to the PATH

### 2. **Dashboard Installation**
- Executes `2_2_install-dashboard.sh` to install the WordsLab Notebooks dashboard

### 3. **JupyterLab Setup**
- Runs `2_3_install-jupyterlab.sh` to install JupyterLab and useful extensions
- Configures JupyterLab to store all its state under the `$WORDSLAB_WORKSPACE` directory

### 4. **Workspace Configuration**
- Calls `2_4_setup-workspace-projects.sh` to create virtual Python environments and IPython kernels for each project

### 5. **Data Science Libraries**
- Executes `2_5_install-datascience-libs.sh $cpu_only` to install:
  - Basic data science libraries
  - PyTorch
  - VLLM (only for GPU installations)
  - Configures popular deep learning libraries to download models and datasets under `$WORDSLAB_MODELS` directory

## Parameters
- Takes `cpu_only` parameter to determine whether to install GPU-specific components (like VLLM)

## Purpose
This script creates a complete, self-contained Python development environment for WordsLab Notebooks that includes:
- Isolated Python environments
- JupyterLab with proper configuration
- Data science libraries (PyTorch, etc.)
- Project-specific virtual environments and kernels
- Proper storage location configuration for notebooks, models, and datasets
- GPU support (when available) with conditional installation

The script serves as the main orchestrator for building the core computational environment needed for machine learning and data science workloads within the WordsLab platform.

# This is the `2_1_install-python-environment.sh` script that installs the Python environment manager and Python version for WordsLab Notebooks. Here's what it does:

## Script Overview
This script installs `uv`, a modern Python package manager, and sets up Python 3.12.11 for use in the WordsLab environment.

## Key Components

### 1. **uv Installation**
- Creates the installation directory specified by `$UV_INSTALL_DIR` (if it doesn't exist)
- Downloads and installs `uv` using the official installation script from `https://astral.sh/uv/install.sh`
- Sources the environment file (`$UV_INSTALL_DIR/env`) to make `uv` available in the current shell

### 2. **Python Version Management**
- Installs Python version 3.12.11 using `uv python install 3.12.11`

## Purpose
This script establishes the Python environment foundation for WordsLab Notebooks by:

1. **Installing uv**: A fast Python package manager and installer that provides:
   - Fast package installation and dependency resolution
   - Virtual environment management
   - Python version management
   - Modern Python workflow tools

2. **Setting Python Version**: Installs a specific Python version (3.12.11) that will be used consistently across the WordsLab environment

## Why uv?
Using `uv` instead of traditional `pip` or `conda` provides:
- Significantly faster installation times
- Better dependency resolution
- Modern Python packaging standards
- Integrated virtual environment management
- Cross-platform compatibility

This creates a solid foundation for the subsequent Python package installations in the WordsLab environment, ensuring consistent package management and Python version control across all components.

# This is the `linux/2_3_install-jupyterlab.sh` script that installs and configures JupyterLab for the WordsLab Notebooks environment. Here's what it does:

## Script Overview
This script initializes the JupyterLab environment, configures directory structures, and installs JupyterLab with its extensions using the `uv` package manager.

## Key Components

### 1. **Directory Preparation**
- Creates the main workspace directory (`$WORDSLAB_WORKSPACE`) if it doesn't exist
- Creates a persistent `.secrets` directory under workspace for storing application secrets

### 2. **JupyterLab Configuration**
- Modifies `_wordslab-notebooks-env.bashrc` to set various JupyterLab directory environment variables:
  - `JUPYTER_CONFIG_DIR` - Configuration directory
  - `JUPYTER_DATA_DIR` - Data directory
  - `JUPYTER_RUNTIME_DIR` - Runtime directory
  - `JUPYTERLAB_SETTINGS_DIR` - User settings directory
  - `JUPYTERLAB_WORKSPACES_DIR` - Workspaces directory
- This ensures all JupyterLab state is stored under the controlled `$WORDSLAB_WORKSPACE` directory

### 3. **Environment Setup**
- Creates the JupyterLab environment directory (`$JUPYTERLAB_ENV`)
- Copies the `2_3_jupyterlab-pyproject.toml` configuration file to the environment directory
- Uses `uv sync` to download and install JupyterLab and all its extensions

## Purpose
This script establishes a complete, persistent JupyterLab environment that:
- Stores all JupyterLab data in the designated workspace directory
- Ensures consistent configuration across installations
- Uses `uv` for fast, reliable package installation
- Maintains proper separation of JupyterLab data from system directories
- Provides a controlled environment for notebook development

The configuration ensures that all JupyterLab state, settings, and extensions are properly managed within the WordsLab storage structure, making the environment portable and consistent.

# This is the `linux/2_3_jupyterlab-pyproject.toml` configuration file that defines the JupyterLab environment dependencies for WordsLab Notebooks. Here's what it does:

## File Overview
This is a standard Python project configuration file (pyproject.toml) that specifies the JupyterLab environment requirements and dependencies.

## Key Components

### 1. **Project Metadata**
- **name**: "jupyterlab-env" - Identifies the environment name
- **version**: "0.1.0" - Version identifier
- **description**: "wordslab-notebooks jupyterlab environment" - Purpose description
- **requires-python**: ">=3.12,<3.13" - Specifies Python version compatibility (3.12.x series)

### 2. **Dependencies**
The file lists 9 key packages:
- **jupyterlab==4.4.9** - Core JupyterLab application
- **ipympl==0.9.7** - Interactive matplotlib widget for Jupyter
- **jupyterlab-execute-time==3.2.0** - Shows execution time of cells
- **jupyterlab-git==0.51.2** - Git integration for JupyterLab
- **jupyterlab-nvdashboard==0.13.0** - NVIDIA dashboard for monitoring GPU usage
- **pynvml==12.0.0** - Python bindings for NVIDIA Management Library
- **jupyter-ai==2.31.6** - AI assistant extension for JupyterLab
- **langchain-ollama==0.3.8** - LangChain integration with Ollama
- **langchain-openai==0.3.33** - LangChain integration with OpenAI

## Purpose
This configuration file serves as the dependency specification for the JupyterLab environment, ensuring that:

1. **Consistent Installation**: All required packages are installed with specified versions
2. **Environment Isolation**: Creates a self-contained JupyterLab environment
3. **Feature Richness**: Provides a comprehensive set of tools including:
   - Core notebook functionality
   - Data visualization capabilities
   - Git integration
   - GPU monitoring
   - AI/ML extensions
   - Language model integrations

## Integration with Installation
When `2_3_install-jupyterlab.sh` runs `uv sync`, it reads this configuration file to:
- Resolve and install all specified dependencies
- Create a consistent, reproducible JupyterLab environment
- Ensure all extensions are properly configured and available

This file essentially defines the "recipe" for building the WordsLab Notebooks JupyterLab environment with all the necessary tools for data science and AI development work.

# This is the `linux/2_4_activate-workspace-project` script that activates a specific Python virtual environment for a WordsLab Notebooks project. Here's what it does:

## Script Overview
This script provides a convenient way to activate Python virtual environments for specific projects within the WordsLab workspace, ensuring proper isolation and project-specific dependencies.

## Key Components

### 1. **Parameter Validation**
- Checks if a project directory name is provided as the first argument
- Displays usage instructions if no argument is given
- Validates that the specified project directory exists within `$WORDSLAB_WORKSPACE`

### 2. **Directory Navigation**
- Changes to the specified project directory (`$WORDSLAB_WORKSPACE/$dir_name`)

### 3. **Environment Activation**
- Activates the Python virtual environment located at `.venv/bin/activate` within the project directory
- Prints a confirmation message indicating which project environment is being activated

## Purpose
This script serves as a utility for developers working with multiple projects in the WordsLab environment by:

1. **Project Isolation**: Ensures each project has its own isolated Python environment
2. **Easy Activation**: Provides a simple command to switch between different project environments
3. **Workspace Integration**: Works seamlessly with the WordsLab workspace structure
4. **Consistent Workflow**: Standardizes how developers activate project-specific environments

## Usage Example
```bash
# Activate a project named "myproject"
source activate-workspace-project myproject

# This would activate the environment at:
# $WORDSLAB_WORKSPACE/myproject/.venv/bin/activate
```

## Integration with Workspace Structure
The script assumes:
- Projects are organized as subdirectories within `$WORDSLAB_WORKSPACE`
- Each project directory contains a `.venv` directory with a Python virtual environment
- The virtual environment uses the standard `activate` script in `.venv/bin/activate`

This enables developers to work on multiple projects with different Python dependencies without conflicts, maintaining the isolation benefits of virtual environments while working within the structured WordsLab workspace.

# This is the `linux/2_4_create-workspace-project` script that creates new project directories with associated Python virtual environments and Jupyter kernels for WordsLab Notebooks. Here's what it does:

## Script Overview
This script automates the creation of new projects within the WordsLab workspace, setting up proper directory structure, version control, Python environments, and Jupyter kernel integration.

## Key Components

### 1. **Parameter Handling**
- Accepts one or two arguments:
  - First argument: Project name or Git repository URL
  - Second argument (optional): Custom project directory name for Git repositories
- Provides usage instructions if no arguments are given
- Validates that the project directory doesn't already exist

### 2. **Project Directory Creation**
- Creates the project directory in `$WORDSLAB_WORKSPACE`
- Changes to the new project directory
- Handles both Git repository cloning and empty project initialization

### 3. **Git Repository Setup**
- Clones Git repositories when a `.git` URL is provided
- Initializes empty Git repositories for new projects
- Adds `.venv` to `.gitignore` to prevent virtual environment from being tracked

### 4. **Python Virtual Environment Creation**
The script uses `uv` (a fast Python package manager) to create project-specific environments with different strategies based on project files:

**If `pyproject.toml` exists:**
- Adds `ipykernel` dependency
- Uses `uv sync` with appropriate CUDA/CPU extras

**If `requirements.txt` exists:**
- Creates virtual environment with `uv venv`
- Synchronizes dependencies with `uv pip sync`
- Installs `ipykernel` for Jupyter integration

**If neither file exists:**
- Copies a default `2_5_datascience-pyproject.toml` template
- Renames the project in the template
- Uses `uv sync` with appropriate extras

### 5. **Jupyter Kernel Integration**
- Installs a Jupyter kernel named after the project
- This allows selecting the project-specific environment when creating new notebooks

## Purpose
This script streamlines the project creation workflow by:

1. **Automated Setup**: Creates complete project environments with one command
2. **Version Control**: Initializes Git repositories with proper ignore rules
3. **Environment Isolation**: Creates project-specific Python virtual environments
4. **Jupyter Integration**: Makes project environments available as Jupyter kernels
5. **Flexibility**: Supports both Git repository cloning and empty project creation
6. **Consistency**: Ensures all projects follow the same structure and setup patterns

## Usage Examples
```bash
# Create empty project
create-workspace-project myproject

# Clone Git repository (uses repo name as directory)
create-workspace-project https://github.com/fastai/fastbook.git

# Clone Git repository with custom directory name
create-workspace-project https://github.com/fastai/fastbook.git mybook

# Create project from existing requirements.txt
create-workspace-project myproject
# (then add requirements.txt to the directory)
```

## Integration with Workspace Structure
The script works within the WordsLab ecosystem by:
- Placing projects in `$WORDSLAB_WORKSPACE` for consistent storage
- Using the established virtual environment and kernel infrastructure
- Leveraging the existing `$WORDSLAB_WORKSPACE/.cpu-only` flag for hardware detection
- Maintaining compatibility with the broader WordsLab installation process

This enables developers to quickly spin up new projects with properly configured environments, dependencies, and Jupyter integration while maintaining the isolated, reproducible nature of the WordsLab workspace.

# This is the `linux/2_4_delete-workspace-project` script that removes project directories along with their associated Jupyter kernels from the WordsLab workspace. Here's what it does:

## Script Overview
This script provides a clean way to completely remove projects from the WordsLab workspace, ensuring that both the project files and associated Jupyter kernel configurations are properly deleted.

## Key Components

### 1. **Parameter Validation**
- Checks if a project directory name is provided as the first argument
- Displays usage instructions if no argument is given
- Validates that the specified project directory exists within `$WORDSLAB_WORKSPACE`

### 2. **Jupyter Kernel Cleanup**
- **Activates the project environment** using the existing `activate-workspace-project` script
- **Uninstalls the Jupyter kernel** associated with the project using `jupyter kernelspec uninstall -y $dir_name`
- This prevents orphaned kernel references in JupyterLab

### 3. **Project Directory Deletion**
- **Deletes the entire project directory** including all files and subdirectories
- Uses `rm -rf` to recursively remove the directory and its contents
- Removes both the project files and the associated virtual environment

## Purpose
This script serves as a safe and complete project cleanup tool by:

1. **Preventing Orphaned Kernels**: Ensures Jupyter doesn't have references to deleted environments
2. **Complete Removal**: Deletes all traces of the project including files, virtual environments, and kernel configurations
3. **Workspace Maintenance**: Helps keep the workspace clean and organized
4. **Resource Management**: Frees up disk space by removing unused projects

## Usage Example
```bash
# Delete a project named "myproject"
delete-workspace-project myproject

# This would:
# 1. Uninstall the "myproject" Jupyter kernel
# 2. Delete the entire $WORDSLAB_WORKSPACE/myproject directory
```

## Integration with Workspace Structure
The script works within the WordsLab ecosystem by:
- Operating on projects within `$WORDSLAB_WORKSPACE`
- Using the established kernel management system
- Leveraging the existing project activation infrastructure
- Maintaining consistency with the overall workspace management approach

## Safety Features
- **Validation**: Checks that the project exists before attempting deletion
- **Error Prevention**: Prevents accidental deletion of non-existent projects
- **Complete Cleanup**: Ensures no remnants of the project remain in the system

This script provides a clean way to manage the lifecycle of projects in the WordsLab workspace, allowing developers to remove projects completely while maintaining system integrity.

# This is the `linux/2_5_install-datascience-libs.sh` script that configures data science library environments and sets up tutorial projects for WordsLab Notebooks. Here's what it does:

## Script Overview
This script serves as a configuration and setup utility that:
1. Handles CPU-only mode flag
2. Sets up model download directories for popular AI libraries
3. Manages tutorial project installation
4. Prepares the environment for data science library installations

## Key Components

### 1. **CPU-Only Mode Configuration**
- Accepts a `cpu_only` parameter as the first argument
- If set to "true", creates a `.cpu-only` marker file in `$WORDSLAB_WORKSPACE`
- This flag is used by other scripts to determine whether to install GPU-optimized versions of libraries

### 2. **Model Download Directory Setup**
- Creates the `$WORDSLAB_MODELS` directory if it doesn't exist
- Configures environment variables in `_wordslab-notebooks-env.bashrc` for popular AI libraries to store their models and datasets in the designated models directory:
  - **Hugging Face**: `HF_HOME` → `$WORDSLAB_MODELS/huggingface`
  - **FastAI**: `FASTAI_HOME` → `$WORDSLAB_MODELS/fastai`
  - **PyTorch**: `TORCH_HOME` → `$WORDSLAB_MODELS/torch`
  - **Keras**: `KERAS_HOME` → `$WORDSLAB_MODELS/keras`
  - **TensorFlow Hub**: `TFHUB_CACHE_DIR` → `$WORDSLAB_MODELS/tfhub_modules`
  - **Ollama**: `OLLAMA_MODELS` → `$WORDSLAB_MODELS/ollama`

### 3. **Tutorial Project Management**
- **Removes existing tutorial project** if it already exists (`$WORDSLAB_WORKSPACE/wordslab-notebooks-tutorials`)
- **Creates a new tutorial project** by cloning the official WordsLab tutorials repository
- This ensures users always have the latest tutorial content when upgrading WordsLab versions

### 4. **Integration with Other Scripts**
- The script sets up the environment so that `create-workspace-project` (called for the tutorials) will:
  - Copy a `pyproject.toml` file from `../projects/`
  - Install common data science libraries
  - Install PyTorch (with GPU or CPU version based on the CPU-only flag)
  - Install VLLM (GPU version)

## Purpose
This script provides the foundational configuration for the WordsLab data science environment by:

1. **Centralized Model Storage**: Ensures all AI libraries download models to a consistent location (`$WORDSLAB_MODELS`)
2. **Environment Consistency**: Sets up proper environment variables for popular libraries
3. **Tutorial Availability**: Maintains up-to-date tutorial content for users
4. **Hardware Flexibility**: Supports both CPU and GPU installations through the CPU-only flag
5. **Upgrade Management**: Automatically replaces old tutorial projects during version upgrades

## Integration with Workspace Structure
The script works within the WordsLab ecosystem by:
- Using the established `$WORDSLAB_MODELS` and `$WORDSLAB_WORKSPACE` variables
- Leveraging the existing `_wordslab-notebooks-env.bashrc` for environment configuration
- Working with the `create-workspace-project` infrastructure to set up tutorial environments
- Supporting the broader installation workflow that includes library dependencies

## Usage
```bash
# Install with GPU support
install-datascience-libs.sh

# Install with CPU-only support  
install-datascience-libs.sh true
```

This script is a crucial part of the WordsLab setup process, ensuring that all data science libraries are properly configured to use the designated models storage location and that users have access to the latest tutorial content.

This is the `linux/2_5_datascience-pyproject.toml` configuration file that defines the Python package dependencies and installation requirements for WordsLab's data science environment. Here's what it does:

## File Overview
This is a [pyproject.toml](file:///home/user/wordslab-notebooks/linux/2_5_datascience-pyproject.toml) configuration file that specifies Python package dependencies, optional dependencies, and dependency resolution rules for the WordsLab data science environment.

## Key Components

### 1. **Project Metadata**
```toml
[project]
name = "project"
version = "0.1.0"
description = "Add your project description here"
requires-python = ">=3.12,<3.13"
```
- Defines a generic project name and version
- Sets Python version requirement to 3.12.x (specifically targeting Python 3.12)

### 2. **Core Dependencies**
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
- **Data Analysis**: pandas, scikit-learn
- **Deep Learning Frameworks**: fastai, ollama
- **Jupyter Integration**: nbdev, jupyter-ai-magics
- **AI/ML Tools**: langchain-ollama, langchain-openai

### 3. **Optional Dependencies (CPU vs CUDA)**
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
  "vllm==0.10.2"
]
```
- **CPU Version**: Basic PyTorch libraries (torch, torchvision, torchaudio)
- **CUDA Version**: Same PyTorch libraries plus VLLM (a high-performance LLM inference engine) for GPU acceleration

### 4. **Development Dependencies**
```toml
[dependency-groups]
dev = [
    "ipykernel==6.30.1",
]
```
- Includes ipykernel for Jupyter notebook kernel support

### 5. **Dependency Conflict Resolution**
```toml
[tool.uv]
conflicts = [
  [
    { extra = "cpu" },
    { extra = "cuda" },
  ],
]
```
- Prevents installation of both CPU and CUDA versions simultaneously
- Ensures only one PyTorch variant is installed

### 6. **PyTorch Index Configuration**
```toml
[tool.uv.sources]
torch = [
  { index = "pytorch-cpu", extra = "cpu" },
  { index = "pytorch-cu128", extra = "cuda" },
]
# ... similar for torchvision and torchaudio
```
- **CPU Index**: `https://download.pytorch.org/whl/cpu` for CPU-only installations
- **CUDA Index**: `https://download.pytorch.org/whl/cu128` for GPU installations

### 7. **Repository Index Definitions**
```toml
[[tool.uv.index]]
name = "pytorch-cpu"
url = "https://download.pytorch.org/whl/cpu"
explicit = true

[[tool.uv.index]]
name = "pytorch-cu128"
url = "https://download.pytorch.org/whl/cu128"
explicit = true
```
- Defines the specific PyTorch package repositories for CPU and CUDA versions
- `explicit = true` ensures these indexes are only used when explicitly requested

## Purpose and Functionality

### 1. **Flexible Installation Support**
- Supports both CPU-only and GPU-accelerated environments
- Automatically selects the appropriate PyTorch variant based on system capabilities
- Provides VLLM only for GPU installations

### 2. **Version Pinning**
- Uses specific version numbers for all packages to ensure reproducible environments
- Locks versions to prevent breaking changes during updates

### 3. **Dependency Management**
- Uses the [uv](file:///home/user/wordslab-notebooks/linux/2_5_datascience-pyproject.toml#L25-L25) package manager with explicit index configuration
- Prevents conflicts between CPU and CUDA versions of PyTorch libraries

### 4. **Integration with Installation Workflow**
- Works with the `install-datascience-libs.sh` script to determine which dependencies to install
- The script's `cpu_only` parameter controls whether CPU or CUDA dependencies are selected
- The `create-workspace-project` function uses this file to set up project environments

## Usage in WordsLab Context
This configuration file is used by the `create-workspace-project` function to:
1. Install the base data science libraries
2. Install the appropriate PyTorch variant (CPU or CUDA) based on the system
3. Install VLLM for GPU-accelerated LLM inference when available
4. Set up a consistent Python environment for data science projects

The file essentially defines the "recipe" for creating reproducible, well-configured Python data science environments that can be either CPU-only or GPU-accelerated, depending on the user's hardware capabilities.

# Based on the content of `linux/3__install-vscode-server.sh`, this is a configuration script that orchestrates the installation of development tools for the WordsLab environment. Here's what it does:

## Script Overview

This script serves as a coordinator that:
1. **Installs Visual Studio Code server** - Runs the `3_1_install-vscode-server.sh` script to set up the VS Code server component
2. **Installs Aider AI code assistant** - Executes the `3_2_install-aider-ai-agent.sh` script to add an AI-powered coding assistant

## Key Features

- **Parameter handling**: Takes a `cpu_only` parameter (passed as `$1`) which likely influences whether to install CPU-only or GPU-enabled versions of tools
- **Modular approach**: Delegates specific installation tasks to separate, specialized scripts
- **Development environment enhancement**: Adds IDE and AI assistant tools to the WordsLab workspace

## Context

This script is part of a larger ecosystem that:
- Manages project creation and setup (`create-workspace-project`)
- Handles dependency management (`install-datascience-libs.sh`)
- Configures data science environments (`pyproject.toml`)
- Now extends to development tooling with VS Code server and AI assistants

The script appears to be part of the workspace initialization process, adding developer productivity tools to the environment after the core data science setup is complete. It's designed to work in conjunction with the CPU/GPU configuration system, as indicated by the `cpu_only` parameter handling.

# Based on the content of `linux/3_1_install-vscode-server.sh`, this script installs and configures Visual Studio Code server (code-server) for the WordsLab environment. Here's what it does:

## Script Overview

This script installs Visual Studio Code server in a persistent directory and configures it with essential extensions for data science development.

## Key Functions

1. **Installs Visual Studio Code server**:
   - Downloads and installs code-server version 4.104.2 using the official install script
   - Installs in a standalone method to a specified `$VSCODE_DIR` directory
   - Uses the `--prefix` parameter to define where code-server will be installed

2. **Creates persistent data directory**:
   - Makes a `$VSCODE_DATA` directory for storing code-server state and configuration
   - This ensures that VS Code server data persists across sessions

3. **Installs Python extension**:
   - Installs the official Microsoft Python extension (version 2025.14.0)
   - Places the extension in the configured extensions directory
   - This provides Python language support, IntelliSense, debugging capabilities

4. **Installs Continue AI assistant**:
   - Installs the Continue AI code assistant extension (version 1.2.6)
   - Uses a separate global directory (`$VSCODE_DATA/.continue`) for Continue's data
   - This provides AI-powered coding assistance within VS Code

## Integration with WordsLab Environment

The script relies on environment variables:
- `$VSCODE_DIR`: Directory where code-server is installed
- `$VSCODE_DATA`: Directory for code-server data and extensions

This installation enables developers to access a full-featured VS Code environment with Python support and AI assistance directly in the WordsLab workspace, enhancing the development experience for data science projects.

# Based on the content of `linux/3_2_install-aider-ai-agent.sh`, this script installs the Aider AI pair programming tool in the WordsLab environment. Here's what it does:

## Script Overview

This is a simple but important script that installs **Aider**, an AI pair programming tool that operates directly in the terminal.

## Key Function

- **Installs Aider using uv tool manager**: 
  - Uses `uv tool install` to install the `aider-chat` package
  - Installs version 0.86.1 of Aider
  - The `uv` tool manager is used for dependency resolution and installation

## What Aider Does

Aider is an AI coding assistant that:
- Works directly in your terminal/command line
- Can help write, edit, and debug code
- Provides pair programming assistance
- Integrates with your existing codebase
- Supports multiple programming languages (particularly Python in this context)

## Integration with WordsLab

This installation is part of the development tooling setup for WordsLab notebooks. It provides developers with:
- Terminal-based AI assistance for coding tasks
- Pair programming support within the WordsLab environment
- Integration with the existing Python development setup
- Enhancement of the development workflow alongside VS Code server

The script is straightforward but essential for providing AI-powered coding assistance in the WordsLab workspace, complementing the VS Code server installation that provides a graphical interface for AI assistance.

# Based on the content of `linux/4__install-open-webui.sh`, this is a configuration script that orchestrates the installation of a local AI/LLM (Large Language Model) development environment. Here's what it does:

## Script Overview

This script serves as a coordinator that installs a complete local AI/LLM ecosystem with three interconnected components:

## Key Components Installed

1. **Ollama** (via `4_1_install-ollama.sh`):
   - Installs Ollama, a platform for running local Large Language Models
   - Enables running LLMs directly on your machine without cloud dependencies
   - Provides a simple interface for managing and running various LLMs locally

2. **Open WebUI** (via `4_2_install-open-webui.sh`):
   - Installs Open WebUI, a web-based chat interface for interacting with LLMs
   - Provides a user-friendly graphical interface for chatting with local models
   - Supports multiple models and offers a multi-model chat experience
   - Enables web-based access to your local LLM capabilities

3. **Docling** (via `4_3_install-docling.sh`):
   - Installs Docling, a document extraction tool
   - Enables processing and extracting information from various document formats
   - Likely integrates with the LLM ecosystem for document-based AI applications

## Integration with WordsLab

This script represents the advanced AI capabilities layer of the WordsLab environment, extending beyond basic data science tools to include:
- Local LLM inference capabilities
- Web-based chat interfaces for AI interaction
- Document processing capabilities
- Complete AI/ML development environment

The script follows the modular approach of the WordsLab setup, delegating specific installations to specialized scripts while providing a unified entry point for the complete AI ecosystem installation.

# Based on the content of `linux/4_1_install-ollama.sh`, this script installs and configures Ollama, a platform for running local Large Language Models (LLMs), within the WordsLab environment. Here's what it does:

## Script Overview

This comprehensive script installs Ollama and sets up a complete local LLM ecosystem with automatic model selection based on system capabilities.

## Key Functions

### 1. **Ollama Installation**
- Creates a persistent directory for Ollama using `$OLLAMA_DIR`
- Downloads the latest Ollama binary (version 0.12.3) for Linux AMD64 architecture
- Extracts the binary to the configured directory
- Adds Ollama to the system PATH by updating `_wordslab-notebooks-env.bashrc`

### 2. **Ollama Server Setup**
- Starts the Ollama server in the background
- Waits for the server to become ready (checks localhost:11434)
- Configures appropriate models based on system resources

### 3. **Intelligent Model Selection**
The script automatically chooses the best LLM based on available GPU memory:
- **CPU-only mode**: Uses smaller models (gemma3:1b, qwen3:1.7b, etc.)
- **GPU mode**: Selects larger models based on VRAM capacity:
  - 23GB+ VRAM: gemma3:27b, qwen3-coder:30b
  - 15-23GB VRAM: gemma3:12b, qwen3:14b  
  - <15GB VRAM: gemma3:4b, qwen3:4b

### 4. **Configuration and Model Download**
- Saves selected model names as environment variables in `_wordslab-notebooks-env.bashrc`
- Downloads all selected default LLMs using `ollama pull`
- Stops the Ollama server process

### 5. **Integration with Development Tools**
- **Jupyter AI Extension**: Configures Ollama models for use with Jupyter AI, setting up:
  - Chat model for conversation
  - Embedding model for vector operations
  - Completion model for code completion
- **VS Code Continue Extension**: Configures Ollama models for use with Continue.dev VS Code extension, providing:
  - Code completion capabilities
  - Chat functionality
  - Embedding support
  - Context providers for various development tasks

## Integration with WordsLab Environment

This script creates a complete local AI/LLM development infrastructure that:
- Provides offline LLM capabilities
- Automatically optimizes for system resources
- Integrates with both Jupyter and VS Code environments
- Enables AI-assisted coding and chat functionality
- Supports both CPU and GPU configurations
- Maintains persistent model storage and configuration

The installation is designed to be persistent and properly integrated with the WordsLab development workflow, enabling developers to work with local LLMs for coding assistance, chat, and document processing tasks.

# Based on the content of `linux/4_2_install-open-webui.sh`, this script installs and configures Open WebUI, a web-based interface for interacting with LLMs, within the WordsLab environment. Here's what it does:

## Script Overview

This script sets up Open WebUI with proper environment configuration, dependency management, and system integration for local AI/LLM development.

## Key Functions

### 1. **Directory Setup**
- Creates the main Open WebUI data directory (`$OPENWEBUI_DATA`)
- Sets up subdirectories for functions and tools within the data directory

### 2. **Environment Configuration**
- Creates a dedicated virtual environment directory (`$OPENWEBUI_ENV`)
- Copies a specialized `pyproject.toml` configuration file to the environment
- Uses `uv sync` to install dependencies with either CPU or CUDA extras based on system configuration

### 3. **Special Handling for UV Link Mode**
- Implements a workaround for UV's symlink mode compatibility issues with Open WebUI
- Manually copies the Open WebUI package from UV cache to avoid duplicate CUDA libraries
- This ensures efficient disk usage while maintaining compatibility

### 4. **HTTPS Support Patch**
- Modifies the Open WebUI server initialization file to support HTTPS secure access
- Adds SSL keyfile and certificate file parameters to the server configuration
- Enables secure HTTPS connections for the web interface

### 5. **Model Initialization**
- Sets up the environment by sourcing the WordsLab environment configuration
- Activates the virtual environment
- Configures CUDA usage based on system capabilities
- Downloads and initializes a small Whisper model for speech-to-text functionality
- The script configures the faster_whisper model with "small" size for efficient processing

## Integration with WordsLab Environment

This script creates a complete Open WebUI installation that:
- Provides a web-based interface for LLM interaction
- Supports both CPU and GPU configurations through UV's dependency management
- Enables secure HTTPS access
- Integrates with the existing WordsLab environment variables and conventions
- Sets up proper data storage locations for models, functions, and tools
- Includes speech-to-text capabilities through Whisper model integration

The installation is designed to work seamlessly within the WordsLab ecosystem, providing developers with a user-friendly web interface for interacting with local LLMs while maintaining the performance optimizations and resource management of the WordsLab environment.

# Based on the content of `linux/4_2_openwebui-pyproject.toml`, this is a configuration file that defines the dependency specifications and package management settings for the Open WebUI environment. Here's what it does:

## Configuration Overview

This `pyproject.toml` file serves as the dependency management configuration for the Open WebUI installation, specifically designed to handle both CPU and GPU environments with proper conflict resolution.

## Key Components

### 1. **Project Metadata**
- **Name**: "openwebui-env" - identifies the virtual environment
- **Version**: "0.1.0" - version identifier
- **Python Requirement**: >=3.12,<3.13 - specifies Python version compatibility
- **Core Dependency**: "open-webui==0.6.31" - the main Open WebUI package

### 2. **Optional Dependencies (CPU vs GPU)**
Defines separate dependency sets for different hardware configurations:
- **CPU Extra**: Installs `torch==2.8.0` for CPU-only environments
- **CUDA Extra**: Installs `torch==2.8.0` for GPU environments

### 3. **Conflict Resolution**
- Uses `[tool.uv.conflicts]` to explicitly prevent both CPU and CUDA extras from being activated simultaneously
- This ensures the environment can only use one configuration at a time, preventing dependency conflicts

### 4. **Custom Package Indexes**
- **PyTorch CPU Index**: `https://download.pytorch.org/whl/cpu` - for CPU-specific PyTorch wheels
- **PyTorch CUDA Index**: `https://download.pytorch.org/whl/cu128` - for CUDA-specific PyTorch wheels
- These custom indexes ensure proper PyTorch version selection based on the target hardware

### 5. **Dependency Resolution Strategy**
- When `uv sync --extra cpu` is run, it will:
  - Use the CPU PyTorch index for torch installation
  - Install CPU-optimized packages
- When `uv sync --extra cuda` is run, it will:
  - Use the CUDA PyTorch index for torch installation  
  - Install GPU-optimized packages

## Integration with Installation Script

This configuration file works in conjunction with the installation script to:
- Enable automatic environment selection based on system capabilities
- Ensure proper PyTorch installation for the target hardware
- Prevent dependency conflicts between CPU and GPU configurations
- Support both development workflows (CPU for testing, GPU for performance)

The configuration allows the WordsLab environment to seamlessly switch between CPU and GPU configurations while maintaining proper dependency resolution and avoiding conflicts between different PyTorch versions.

# Based on the content of `linux/4_3_install-docling.sh`, this script installs and configures Docling, a document processing and extraction tool, within the WordsLab environment. Here's what it does:

## Script Overview

This script sets up Docling with proper environment configuration, dependency management, and model initialization for document processing capabilities within the WordsLab ecosystem.

## Key Functions

### 1. **Directory Setup**
- Creates the main Docling data directory (`$DOCLING_DATA`) for storing processed documents
- Creates a separate models directory (`$DOCLING_MODELS`) for storing Docling's model files

### 2. **Environment Configuration**
- Creates a dedicated virtual environment directory (`$DOCLING_ENV`) 
- Copies the `4_3_docling-pyproject.toml` configuration file to the environment
- Uses `uv sync` to install dependencies with either CPU or CUDA extras based on system configuration

### 3. **Dependency Management**
- The script leverages UV's dependency management system with CPU/CUDA support
- Automatically selects the appropriate PyTorch versions based on the system's capabilities
- Uses the custom PyTorch indexes defined in the pyproject.toml configuration

### 4. **Model Initialization**
- Activates the virtual environment
- Downloads and initializes specific Docling models using the `docling-tools models download` command
- The script downloads models for:
  - **layout**: Layout analysis for document structure
  - **tableformer**: Table detection and extraction
  - **code_formula**: Code and formula recognition
  - **picture_classifier**: Image classification
  - **easyocr**: OCR (Optical Character Recognition)

### 5. **Commented-Out Future Enhancements**
The script includes commented-out code that references:
- A temporary patch for compatibility between docling-serve 1.5.1 and Open WebUI 0.6.31
- Future support for granite-docling VLM (Vision-Language Model) integration
- Notes about compatibility issues with HF transformers as of September 28, 2025

## Integration with WordsLab Environment

This script creates a complete Docling installation that:
- Provides document processing capabilities for extracting structured data from documents
- Supports both CPU and GPU configurations through UV's dependency management
- Integrates with the existing WordsLab environment variables and conventions
- Sets up proper data storage locations for documents and models
- Enables automated model downloading and initialization

## Use Case

The installation enables users to:
- Process complex documents with layout analysis
- Extract tables, code, formulas, and text from various document types
- Leverage OCR capabilities for image-based text extraction
- Work with both CPU and GPU configurations depending on system resources
- Integrate document processing capabilities into larger AI/ML workflows within the WordsLab environment

The script is designed to work seamlessly within the WordsLab ecosystem, providing developers with robust document processing capabilities while maintaining the performance optimizations and resource management of the WordsLab environment.

# Based on the content of `linux/4_3_docling-pyproject.toml`, this is a configuration file that defines the dependency specifications and package management settings for the Docling document processing environment. Here's what it does:

## Configuration Overview

This `pyproject.toml` file serves as the dependency management configuration for the Docling installation, specifically designed to handle both CPU and GPU environments with proper conflict resolution for document processing tools.

## Key Components

### 1. **Project Metadata**
- **Name**: "docling-env" - identifies the virtual environment
- **Version**: "0.1.0" - version identifier
- **Python Requirement**: >=3.12,<3.13 - specifies Python version compatibility

### 2. **Core Dependencies**
- **vLLM==0.10.2**: Pinning this version to avoid downloading it twice (performance optimization)
- **docling==2.54.0**: Pinning this version to ensure reproducibility and stable behavior
- **docling-serve[ui]==1.5.1**: Installing Docling Serve with UI components for document processing interface

### 3. **Optional Dependencies (CPU vs GPU)**
Defines separate dependency sets for different hardware configurations:
- **CPU Extra**: Installs `torch==2.8.0` for CPU-only environments
- **CUDA Extra**: Installs `torch==2.8.0` for GPU environments

### 4. **Conflict Resolution**
- Uses `[tool.uv.conflicts]` to explicitly prevent both CPU and CUDA extras from being activated simultaneously
- This ensures the environment can only use one configuration at a time, preventing dependency conflicts

### 5. **Custom Package Indexes**
- **PyTorch CPU Index**: `https://download.pytorch.org/whl/cpu` - for CPU-specific PyTorch wheels
- **PyTorch CUDA Index**: `https://download.pytorch.org/whl/cu128` - for CUDA-specific PyTorch wheels
- These custom indexes ensure proper PyTorch version selection based on the target hardware

## Integration with Installation Script

This configuration file works in conjunction with the installation script to:
- Enable automatic environment selection based on system capabilities (CPU/CUDA)
- Ensure proper PyTorch installation for the target hardware (CPU vs GPU)
- Prevent dependency conflicts between CPU and GPU configurations
- Support both development workflows (CPU for testing, GPU for performance)
- Maintain version pinning for stable document processing capabilities

## Document Processing Capabilities

The configuration enables Docling to provide:
- Layout analysis and document structure extraction
- Table detection and formatting
- Code and formula recognition
- OCR (Optical Character Recognition) capabilities
- Vision-language model integration
- Web-based UI for document processing

## Version Pinning Strategy

The configuration uses explicit version pinning for:
- **vLLM**: Ensures consistent performance and avoids duplicate downloads
- **Docling**: Guarantees reproducible results and stable document processing
- **Docling Serve**: Maintains compatibility with the UI components

The configuration allows the WordsLab environment to seamlessly switch between CPU and GPU configurations while maintaining proper dependency resolution, ensuring reliable document processing capabilities across different hardware setups.

# Analysis of `start-wordslab-notebooks.bat`

This Windows batch script serves as the main entry point for starting the WordsLab Notebooks environment, with support for both local Windows development and remote Linux deployment scenarios.

## Key Functions

### 1. **Dual-Mode Operation**
The script operates in two distinct modes:
- **Local Windows mode**: When run without arguments or with `--name` parameter
- **Remote Linux mode**: When run with server address and optional port as arguments

### 2. **Remote Linux Deployment (Primary Function)**
When arguments are provided, the script:
- Connects to a remote Linux server via SSH
- Detects the platform type (WSL, Jarvislabs.ai, Runpod.io, Vast.ai)
- Sets appropriate home directory paths based on platform
- Handles SSL certificate preparation and transfer if needed
- Executes the Linux startup script (`start-wordslab-notebooks.sh`) remotely

### 3. **Local Windows Development (Secondary Function)**
When run locally on Windows:
- Mounts Linux virtual disks using `4_mount-linux-virtual-disks.bat`
- Checks for SSL certificate existence in the WSL environment
- If certificate exists, configures remote access ports (8880-8888) using PowerShell scripts
- Launches the main startup script within the WSL environment using `wsl -d`

## Key Features

### Platform Detection
- Automatically identifies the deployment platform using SSH connection to remote server
- Supports WSL, Jarvislabs.ai, Runpod.io, and Vast.ai platforms
- Sets appropriate environment variables (`WORDSLAB_HOME`) for each platform

### Certificate Management
- Checks if SSL certificates already exist on the remote server
- Generates new certificate secrets when needed using `prepare-server-secrets.bat`
- Transfers certificate files to the remote server via SCP

### Remote Access Configuration
- For local Windows mode, sets up port forwarding for remote access
- Uses PowerShell with administrator privileges when needed
- Handles WSL IP address changes automatically

### Environment Management
- Properly handles relative paths and directory navigation
- Uses delayed variable expansion for dynamic environment handling
- Manages SSH connections with proper key authentication

## Execution Flow

1. **Parameter parsing** - Determines if running locally or remotely
2. **Platform detection** - Identifies deployment environment via SSH
3. **Certificate preparation** - Sets up SSL certificates if needed
4. **Remote execution** - Runs the main startup script either locally or on remote server
5. **Cleanup** - Proper script termination

This script provides a unified interface for deploying WordsLab Notebooks across different environments while handling the complexities of cross-platform deployment, SSL certificate management, and remote access configuration.

# Analysis of `start-wordslab-notebooks.sh`

This is the main startup script for the WordsLab Notebooks environment, written in Bash for Linux/WSL systems. It serves as the entry point that orchestrates the complete startup sequence of the entire WordsLab ecosystem.

## Key Functions

### 1. **Environment Configuration**
- **Default Path Setting**: Sets `WORDSLAB_HOME` to `/home` if not already defined
- **Directory Navigation**: Changes to the `linux` directory where all related scripts are located
- **Runpod Environment Handling**: Specifically addresses Runpod platform requirements by modifying `.bashrc` if needed

### 2. **Environment Variable Initialization**
- Sources `_wordslab-notebooks-env.bashrc` to load all necessary environment variables
- This file likely contains platform-specific configurations and service settings

### 3. **System Prerequisites Check**
- **Installation State Check**: Verifies if the system has been properly installed by checking for `/.wordslab-installed` file
- **Reinstallation Logic**: If the installation marker file doesn't exist, runs `1__update-operating-system.sh` to reinstall OS packages and reconfigure the shell
- This ensures proper initialization even after container restarts or system resets

### 4. **Main Service Startup**
- **Primary Execution**: Calls `5_start-wordslab-notebooks.sh` to initiate all services
- This represents the core orchestration script that manages the complete startup sequence

## Execution Flow

1. **Environment Setup** - Configure paths and variables
2. **Platform Detection** - Handle Runpod-specific requirements
3. **Environment Loading** - Load all required environment variables
4. **System Check** - Verify installation status and reinstall if needed
5. **Service Orchestration** - Launch all WordsLab services via the main orchestrator

## Key Features

### Flexibility
- Supports customizable installation paths through environment variables (`WORDSLAB_HOME`, `WORDSLAB_WORKSPACE`, `WORDSLAB_MODELS`)
- Handles different deployment scenarios (local WSL, cloud platforms like Runpod)

### Robustness
- **Self-Healing**: Automatically reinstalls system packages if the installation marker is missing
- **Platform Awareness**: Adapts to different deployment environments (Runpod, WSL, etc.)
- **Idempotent Operation**: Can be safely run multiple times without adverse effects

### Modular Design
- Follows a layered approach where each script has a specific responsibility
- Leverages other scripts in the system for specific tasks (OS updates, service startup, etc.)

This script essentially serves as the master controller that ensures the WordsLab Notebooks environment is properly initialized and all required services are started in the correct sequence, handling both first-time installations and restart scenarios.

# Based on the content of `linux/5_start-wordslab-notebooks.sh`, this is a comprehensive startup script that orchestrates the entire WordsLab Notebooks environment by launching multiple interconnected services within a Docker container. Here's what it does:

## Script Overview

This bash script serves as the main entry point for starting the complete WordsLab Notebooks ecosystem, managing service startup, environment configuration, and process lifecycle management.

## Key Functions

### 1. **Docker Environment Management**
- Checks if running inside a Docker container using `/.dockerenv` file detection
- Automatically starts Docker daemon if not already running and not in container
- Ensures proper container environment setup

### 2. **URL Environment Variable Export**
- Uses Python script `5_export-wordslab-urls.py` to dynamically export application URLs
- Sets up URLs for:
  - JupyterLab
  - VS Code
  - Open WebUI
  - User applications (5 additional apps)
  - Dashboard
- Enables centralized URL management for all services

### 3. **Security Configuration Management**
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

### 4. **Service Startup Commands**

#### **Visual Studio Code Server**
- Launches code-server with specified port binding
- Configures secure parameters based on certificate availability
- Uses Continue AI extensions and custom data directories

#### **JupyterLab Server**
- Activates the JupyterLab virtual environment
- Starts server with:
  - Public IP binding (0.0.0.0)
  - Custom port configuration
  - Security parameters for HTTPS
  - Root access and remote access enabled
  - Workspace root directory set to WordsLab workspace

#### **Ollama Server**
- Launches Ollama language model server with:
  - Host binding to 0.0.0.0
  - Custom context length and memory settings
  - Optimized attention and estimation parameters

#### **Docling Server** (Conditional)
- Starts Docling document extraction service when enabled via environment variable
- Configures connection parameters for Open WebUI integration
- Sets up OCR engine and language support

#### **Open WebUI Server**
- Activates Open WebUI virtual environment
- Configures CUDA usage based on `.cpu-only` flag
- Sets up environment variables for:
  - Authentication (disabled)
  - Model configurations
  - Data directory paths
  - Tool and function directories
  - RAG embedding engine settings
  - Whisper model for audio processing

#### **WordsLab Dashboard**
- Starts the WordsLab dashboard service
- Provides centralized monitoring and management interface

### 5. **Process Management and Cleanup**
- Implements process ID tracking for all started services
- Sets up signal trapping for graceful shutdown
- Uses cleanup function to terminate all processes on interrupt
- Waits for all processes to complete

### 6. **User Interface and Output**
- Provides clear startup messages with dashboard URL
- Displays the dashboard URL for user access
- Implements proper sleep delay to ensure services start properly

## Integration Features

### **Environment Variable Handling**
- Uses `$WORDSLAB_WORKSPACE` for project paths
- Manages virtual environment activation for each service
- Configures CUDA vs CPU settings based on `.cpu-only` flag
- Sets up proper library paths for GPU acceleration

### **Security and Authentication**
- Supports HTTPS with certificate-based authentication
- Implements password-based authentication for JupyterLab
- Configures secure service parameters based on available credentials

### **Flexible Deployment**
- Supports both CPU and GPU configurations
- Conditional Docling server startup
- Configurable port assignments
- Robust error handling and fallback mechanisms

## Architecture

This script creates a complete, self-contained WordsLab Notebooks environment that:
- Provides multiple development interfaces (JupyterLab, VS Code, Open WebUI)
- Integrates AI and document processing capabilities (Ollama, Docling)
- Offers centralized dashboard monitoring
- Supports secure, production-ready deployment
- Handles process lifecycle management with proper cleanup

The script essentially transforms a base system into a full-featured AI development environment with proper service orchestration, security management, and user accessibility.

# This Python script `linux/5_export-wordslab-urls.py` dynamically generates and exports URL endpoints for the WordsLab Notebooks environment based on the deployment platform and configuration. Here's what it does:

## Core Functionality

### 1. **Port Configuration**
- Reads environment variables for all service ports:
  - JupyterLab, VS Code, Open WebUI, 5 user applications, and Dashboard
- Stores ports in a list for processing

### 2. **HTTPS Detection**
- Checks if SSL certificates exist in the `.secrets` directory
- Sets URL scheme to `https://` if certificates are present, otherwise `http://`

### 3. **Platform-Specific URL Generation**
The script handles different deployment platforms:

#### **Windows Subsystem for Linux (WSL)**
- Reads IP address from `.WORDSLAB_WINDOWS_IP` file
- Uses this IP with port numbers for all endpoints

#### **Jarvislabs.ai**
- Uses Jarvislabs client API to fetch machine endpoints
- Retrieves actual deployment URLs from the Jarvislabs platform

#### **Runpod.io**
- Constructs URLs using pod ID and port numbers
- Format: `{pod_id}-{port}.proxy.runpod.net`

#### **Vast.ai**
- Uses public IP address and port mappings
- Maps environment variables like `VAST_TCP_PORT_{port}` to actual ports

#### **UnknownLinux (default)**
- Automatically detects local IP address when HTTPS is enabled
- Uses localhost (`127.0.0.1`) when HTTPS is disabled

### 4. **Environment Variable Export**
- Exports all generated URLs as environment variables:
  - `JUPYTERLAB_URL`
  - `VSCODE_URL`
  - `OPENWEBUI_URL`
  - `USER_APP1_URL` through `USER_APP5_URL`
  - `DASHBOARD_URL` (always HTTP for dashboard)

## Key Features

### **Flexible Deployment Support**
- Supports multiple cloud platforms (WSL, Jarvislabs, Runpod, Vast.ai)
- Adapts to different networking environments
- Handles both local development and cloud deployments

### **Security Integration**
- Automatically detects SSL certificate availability
- Uses appropriate URL schemes (HTTP/HTTPS)
- Supports secure deployment configurations

### **Dynamic Configuration**
- Reads configuration from environment variables and files
- Adapts to different deployment contexts
- Provides centralized URL management for all services

## Usage in Workflow

This script is called by the main startup script (`5_start-wordslab-notebooks.sh`) to:
1. Generate all necessary service URLs
2. Export them as environment variables
3. Make them available to all running services
4. Ensure consistent endpoint configuration across the entire WordsLab ecosystem

The script essentially creates a unified interface for accessing all WordsLab services regardless of deployment platform, making the system portable and adaptable to different hosting environments.

# This Bash script `linux/5_1_start-docling-documents-extraction.sh` is responsible for starting the Docling document extraction service within the WordsLab Notebooks environment. Here's what it does:

## Script Overview

This is a simple but essential startup script that launches the Docling document processing server with proper environment configuration and optional port customization.

## Key Components

### 1. **Parameter Handling**
- Accepts an optional port parameter as the first argument
- Defaults to port `5001` if no port is specified
- This port is used for internal communication with Open WebUI or JupyterLab

### 2. **Environment Activation**
- Activates the Docling virtual environment using:
  ```bash
  source $DOCLING_ENV/.venv/bin/activate
  ```
- This ensures the script runs with Docling's specific dependencies and Python environment

### 3. **Environment Variable Configuration**
Sets up three key environment variables for Docling:
- `DOCLING_SERVE_ARTIFACTS_PATH=$DOCLING_MODELS` - Path for Docling artifacts
- `DOCLING_SERVE_SCRATCH_PATH=$DOCLING_DATA` - Path for temporary processing files
- `DOCLING_SERVE_ENABLE_UI=true` - Enables the Docling UI interface

### 4. **Service Execution**
Launches the Docling server with:
- `UVICORN_PORT=${1:-5001}` - Uses provided port or defaults to 5001
- `docling-serve run` - Starts the actual Docling server process
- `&` - Runs the process in the background
- `exit $!` - Exits with the process ID of the background job

## Integration with WordsLab

### **Purpose in Ecosystem**
- Provides document extraction capabilities for the WordsLab environment
- Integrates with Open WebUI and JupyterLab for document processing
- Supports AI-powered document analysis and content extraction

### **Configuration Dependencies**
- Relies on environment variables set elsewhere in the system:
  - `$DOCLING_ENV` - Path to Docling environment
  - `$DOCLING_MODELS` - Model storage directory
  - `$DOCLING_DATA` - Data processing directory

### **Flexibility Features**
- **Port Customization**: Can be run on any port (default 5001)
- **Background Execution**: Runs as daemon process
- **Conditional Startup**: Only starts when explicitly called by the main startup script

## Usage Context

This script is typically called conditionally by the main startup script (`5_start-wordslab-notebooks.sh`) when Docling extraction is enabled. It provides:
- A centralized document processing service
- Integration with other WordsLab components
- Support for both internal and external access (via port selection)
- Proper environment isolation through virtual environment activation

The script represents a modular approach to service management, where Docling is only started when needed, rather than as a permanent background service, making the WordsLab environment more efficient and configurable.

# Analysis of `prepare-client-machine.bat`

This is a Windows batch script designed to prepare a client machine for use with the WordsLab Notebooks environment. It serves as the entry point for setting up the local client environment that will be used to manage remote servers.

## Key Functions

### 1. **Dual-Mode Operation**
The script operates in two contexts:
- **Context 1**: When scripts are already installed locally - uses existing `prepare-server-secrets.bat`
- **Context 2**: When starting from scratch - downloads and installs the complete repository first

### 2. **Repository Installation (When Needed)**
- Creates installation directory (`WORDSLAB_WINDOWS_HOME`, default: `C:\wordslab`)
- Downloads the WordsLab Notebooks repository from GitHub
- Supports both main branch and tagged releases via `WORDSLAB_VERSION` parameter
- Unzips and sets up the scripts directory

### 3. **Secrets Directory Setup**
- Creates a dedicated secrets directory at `..\secrets` relative to the scripts
- Normalizes the secrets directory path for consistent usage

### 4. **Client Secrets Management**
- **Reuses existing secrets**: If `rootCA.pem` exists, it reuses client secrets from `wordslab-client-secrets.tar`
- **Generates new SSH key**: Creates an ED25519 SSH key pair for secure communication
- **Downloads mkcert**: Automatically downloads and installs the mkcert certificate utility for local HTTPS

### 5. **Archive Creation**
- Creates a tar archive (`wordslab-client-secrets.tar`) containing all client secrets
- This archive can be transferred to other client machines for consistent setup

## Execution Flow

1. **Detection**: Checks if `prepare-server-secrets.bat` exists (determines installation context)
2. **Installation**: If needed, downloads and extracts the full repository
3. **Directory Setup**: Creates and configures secrets directory
4. **Secret Generation**: 
   - Generates SSH key pair
   - Downloads and installs mkcert
5. **Archive Creation**: Packages all client secrets into a tar file
6. **Instructions**: Provides detailed usage instructions for next steps

## Key Features

### Automation
- Fully automated client setup process
- Handles all prerequisites automatically (SSH keys, certificates)
- Self-contained - no manual intervention required for basic setup

### Security
- Generates secure ED25519 SSH keys for authentication
- Uses mkcert for local certificate authority installation
- Manages secrets in a dedicated, secure directory structure

### Cross-Platform Support
- Windows-specific batch scripting
- Handles Windows path conventions and directory structures
- Prepares for both local and cloud server deployments

### Reusability
- Creates reusable secret archives for multiple client machines
- Provides clear instructions for transferring secrets between machines
- Supports consistent deployment across different environments

## Usage Instructions Provided

The script outputs detailed instructions for:
1. **Registering SSH keys** with cloud providers
2. **Installing on cloud servers** using `install-wordslab-notebooks.bat`
3. **Generating local server secrets** using `prepare-server-secrets.bat`
4. **Transferring secrets** between client machines

## Purpose

This script serves as the **client preparation tool** in the WordsLab Notebooks ecosystem. It establishes the local client environment with all necessary credentials and tools needed to:
- Deploy WordsLab Notebooks on remote servers
- Manage secure SSH connections
- Handle HTTPS certificates for local development
- Maintain consistent secret management across multiple client machines

The script essentially creates a "client workstation" that can then be used to deploy and manage WordsLab Notebooks environments on remote cloud servers.

# Analysis of `prepare-server-secrets.bat`

This is a Windows batch script designed to prepare server-side secrets for a WordsLab Notebooks deployment. It's the second component in the client-server setup workflow, following `prepare-client-machine.bat`.

## Key Functions

### 1. **Prerequisite Verification**
- Validates that the client machine has been prepared first by checking:
  - Presence of `mkcert.exe` in the scripts directory
  - Presence of `rootCA-key.pem` in the secrets directory
- If prerequisites aren't met, it exits with an error, directing users to run `prepare-client-machine.bat` first

### 2. **Secrets Directory Normalization**
- Sets up the proper secrets directory path (`..\secrets` relative to script location)
- Uses `pushd`/`popd` to normalize the path for consistent usage

### 3. **Machine Address Handling**
- Accepts machine address as command-line parameter or prompts user input
- Automatically detects if the input is an IP address or DNS subdomain
- For IP addresses: uses directly
- For DNS subdomains: prepends `*.` for wildcard certificate generation

### 4. **SSL Certificate Generation**
- Uses the previously installed mkcert utility to generate SSL certificates
- Creates certificates for:
  - The specific machine address (with wildcard for DNS subdomains)
  - localhost and 127.0.0.1 for local access
  - IPv6 localhost (::1)
- Stores certificates in the secrets directory with `certificate.pem` and `certificate-key.pem` names

### 5. **Password Management**
- Prompts user for a password to secure access to the remote machine
- If no password provided, creates an empty password file (indicating no password protection)
- Stores the password in the secrets directory

### 6. **Archive Creation**
- Creates a tar archive containing all server-specific secrets:
  - SSL certificate files (`certificate.pem`, `certificate-key.pem`)
  - Password file
- Archives are named with the machine identifier for clear identification
- Removes original certificate and password files after archiving for security

## Execution Flow

1. **Validation**: Ensures client preparation has been completed
2. **Setup**: Normalizes secrets directory path
3. **Input**: Gets machine address (from parameter or user prompt)
4. **Address Processing**: Determines if IP or DNS subdomain, formats accordingly
5. **Certificate Generation**: Creates SSL certificates using mkcert
6. **Password Input**: Gets and stores password for remote access
7. **Archive Creation**: Packages all server secrets into a secure tar file
8. **Cleanup**: Removes original certificate and password files
9. **Output**: Provides instructions for transferring secrets to the server

## Key Features

### Security
- **Certificate Management**: Automatically generates proper SSL certificates for secure HTTPS access
- **Password Handling**: Supports both password-protected and passwordless access
- **Secure Archiving**: Creates encrypted tar archives for safe transfer
- **File Cleanup**: Removes original certificate files after archiving to prevent exposure

### Flexibility
- **Dual Input Methods**: Accepts machine address via command line or interactive prompt
- **Address Type Detection**: Automatically handles both IP addresses and DNS subdomains
- **Wildcard Support**: Generates certificates that work for both specific addresses and wildcards

### Automation
- Fully automated server secret generation
- No manual certificate creation required
- Self-contained script that handles all server preparation steps

## Usage Instructions Provided

The script outputs clear instructions for:
1. **Transferring secrets** to the target server machine
2. **Referencing documentation** for the complete deployment process
3. **Using the generated archive** for server installation

## Purpose

This script serves as the **server preparation tool** in the WordsLab Notebooks ecosystem. It generates all the necessary security credentials and configuration files for a specific remote server, including:

- SSL certificates for HTTPS encryption
- Access passwords for secure remote access
- A packaged archive ready for transfer to the target server

The resulting tar archive (`wordslab-server-[machine]-secrets.tar`) is then transferred to the target server machine and used by the `install-wordslab-notebooks.bat` script to complete the deployment process. This creates a secure, properly configured WordsLab Notebooks environment on the remote server.


# Analysis of `prepare-server-machine.bat`

This is a Windows batch script designed to prepare a WSL (Windows Subsystem for Linux) environment for WordsLab Notebooks deployment. It's the third component in the client-server setup workflow, bridging the gap between client preparation and actual server installation.

## Key Functions

### 1. **Windows IP Address Detection**
- Uses PowerShell to identify the primary non-WSL, non-loopback IPv4 address of the Windows machine
- This IP address represents the Windows host that will be running WSL
- The script filters out WSL interfaces and loopback interfaces to ensure it gets the correct external IP

### 2. **WSL IP File Creation**
- Writes the detected Windows IP address to a special file in the WSL environment
- The file is created at `/home/.WORDSLAB_WINDOWS_IP` within the WSL wordslab-notebooks distribution
- This allows the WSL environment to know the IP address of the Windows host for network configuration

### 3. **Secrets Archive Validation**
- Checks if a corresponding secrets archive exists in the `..\secrets` directory
- The archive name is expected to match the pattern `wordslab-server-[IP]-secrets.tar` where `[IP]` is the detected Windows IP
- This ensures the script only proceeds when the correct secrets have been generated on the client machine

### 4. **WSL Environment Integration**
- If the secrets archive exists, it transfers and extracts the secrets into the WSL workspace
- Uses `wsl -d wordslab-notebooks-workspace` to target the specific WSL distribution
- Creates the `.secrets` directory in the workspace and copies the tar archive
- Extracts the archive contents to make the secrets available to the WSL environment

## Execution Flow

1. **IP Detection**: Uses PowerShell to find the Windows machine's primary IP address
2. **WSL File Creation**: Writes IP address to WSL environment for reference
3. **Archive Verification**: Checks if matching secrets archive exists in `..\secrets` directory
4. **WSL Integration**: If archive exists, copies and extracts secrets to WSL workspace
5. **Error Handling**: Provides clear error message if secrets archive is missing

## Key Features

### Automation
- **Automatic IP Detection**: No manual IP entry required - script discovers it automatically
- **WSL Integration**: Seamlessly integrates with existing WSL environments
- **Dependency Checking**: Validates that required secrets are present before proceeding

### Cross-Platform Compatibility
- **Windows + WSL Bridge**: Acts as a bridge between Windows client environment and WSL server environment
- **WSL Distribution Targeting**: Specifically targets the `wordslab-notebooks-workspace` WSL distribution
- **Path Handling**: Uses WSL's Linux-style paths for file operations

### Security Considerations
- **Secure File Transfer**: Uses WSL's built-in file system for secure secret handling
- **Proper Directory Structure**: Places secrets in `/home/workspace/.secrets` within WSL for consistent access
- **No Manual File Copying**: Eliminates manual file transfer errors

## Purpose

This script serves as the **WSL preparation tool** in the WordsLab Notebooks ecosystem. It:

1. **Identifies the Windows Host**: Determines which Windows machine is running the WSL environment
2. **Configures WSL Environment**: Makes the Windows IP address available to the WSL workspace
3. **Imports Server Secrets**: Transfers the security credentials generated by `prepare-server-secrets.bat` into the WSL environment
4. **Prepares for Installation**: Sets up the WSL environment with all necessary files for the final installation step

## Workflow Integration

This script completes the client-server setup sequence:
1. `prepare-client-machine.bat` - Prepares the Windows client with SSH keys and certificates
2. `prepare-server-secrets.bat` - Generates server-specific secrets and creates a tar archive
3. `prepare-server-machine.bat` - Transfers secrets to WSL and configures the environment
4. `install-wordslab-notebooks.bat` - Installs and starts the full WordsLab Notebooks environment

The script ensures that the WSL environment has all the necessary configuration and security credentials to properly host the WordsLab Notebooks services, making it a crucial bridge between the Windows client setup and the actual server deployment.

# Analysis of `6_allow-remote-access-to-vm-ports.ps1`

This PowerShell script is designed to configure network access for the WordsLab Notebooks virtual machine, enabling remote access to the various services running within the WSL environment. It's the final step in the Windows-based deployment workflow, making the notebooks environment accessible from external machines.

## Key Functions

### 1. **Administrator Privilege Check**
- Validates that the script is running with Administrator privileges
- This is required because the script needs to modify firewall rules and network port configurations
- If not running as Administrator, it displays an error message and exits

### 2. **WSL VM IP Address Detection**
- Uses WSL to query the IP address of the virtual machine's network interface
- Specifically queries `eth0` interface for the IP address
- Extracts the IP address from the network configuration output
- The IP address is used to map external port requests to the correct internal WSL VM

### 3. **Port Configuration**
- Defines a default set of ports that need to be exposed:
  - JupyterLab (8880)
  - VS Code Server (8881)
  - Open WebUI (8882)
  - 5 user-defined applications (8883-8887)
  - Dashboard (8888)
- Accepts additional ports as command-line arguments (extends the default ports)
- Configures port forwarding for each port to map external requests to internal WSL VM ports

### 4. **Network Port Forwarding**
- Uses `netsh interface portproxy add v4tov4` to create port forwarding rules
- Maps external port requests (0.0.0.0) to the internal WSL VM IP address
- This allows external machines to connect to the services running in WSL

### 5. **Firewall Configuration**
- Opens firewall ports for inbound traffic on all configured ports
- Creates a firewall rule named "wordslab-notebooks" to allow TCP traffic
- Uses `netsh advfirewall firewall add rule` to configure the firewall

### 6. **Remote Access URL Display**
- Identifies the primary external IP address of the Windows machine
- Filters out local/loopback addresses (169.254.*, 172.*, 127.*)
- Displays a complete URL that remote users can access the dashboard

## Execution Flow

1. **Privilege Check**: Ensures Administrator rights are available
2. **IP Detection**: Gets the WSL VM's internal IP address
3. **Port Setup**: Defines default ports and accepts additional ports
4. **Port Forwarding**: Creates port proxy rules for each port
5. **Firewall Setup**: Opens firewall ports for inbound access
6. **URL Display**: Shows the accessible URL for remote access

## Key Features

### Security
- **Administrator Required**: Ensures only privileged users can modify network configurations
- **Selective Port Exposure**: Only exposes necessary ports for the services
- **Firewall Integration**: Properly configures Windows firewall rules

### Flexibility
- **Extensible Ports**: Accepts additional ports via command-line arguments
- **Default Port Coverage**: Handles all standard WordsLab services automatically
- **Cross-Platform Compatibility**: Works with WSL's virtualized network environment

### Automation
- **Self-Contained**: Performs all necessary network configuration in one script
- **Error Prevention**: Validates privileges before making system changes
- **User-Friendly**: Provides clear output and final access instructions

## Purpose

This script serves as the **network access configuration tool** in the WordsLab Notebooks ecosystem. It:

1. **Enables Remote Access**: Makes all WordsLab services accessible from external machines
2. **Configures Port Forwarding**: Sets up proper network routing between host and WSL
3. **Secures Network**: Properly configures firewall rules for secure access
4. **Provides Access Instructions**: Shows users exactly how to access the services remotely

## Complete Deployment Workflow

This script completes the Windows-based deployment sequence:
1. `prepare-client-machine.bat` - Prepares Windows client with SSH keys
2. `prepare-server-secrets.bat` - Generates server-specific secrets
3. `prepare-server-machine.bat` - Transfers secrets to WSL
4. `install-wordslab-notebooks.bat` - Installs and starts services
5. `6_allow-remote-access-to-vm-ports.ps1` - Configures network access for remote users

The script transforms a local WSL development environment into a remotely accessible WordsLab Notebooks service, allowing users to access JupyterLab, VS Code Server, Open WebUI, and other services from any machine on the network.

