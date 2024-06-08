# wordslab-notebooks

Simple procedures and scripts to initialize a Jupyterlab workspace with GPU access for AI workloads

## Windows machine

### 0- Download the wordslab-notebook scripts:

Choose the install directory on your machine by replacing %HOMEPATH% with a specific path on your machine.

```
set installdir=%HOMEPATH%

mkdir %installdir%
curl -L -o %installdir%\wordslab-notebooks.zip https://github.com/wordslab-org/wordslab-notebooks/archive/refs/heads/main.zip
tar -x -f %installdir%\wordslab-notebooks.zip -C %installdir%
del %installdir%\wordslab-notebooks.zip
ren %installdir%\wordslab-notebooks-main wordslab-notebooks

```

### 1- Install or update Windows Subsystem for Linux

Open a Command Prompt as Administrator:

```
set installdir=%HOMEPATH%

cd %installdir%\wordslab-notebooks\install\windows-linux
1_install-or-update-windows-subsystem-for-linux.bat

```

Reboot if necessary.

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
