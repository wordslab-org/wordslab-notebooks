# wordslab-notebooks

Simple procedures and scripts to initialize a Jupyterlab workspace with GPU access for AI workloads

# Windows machine

# Step 1: Install or update Windows Subsystem for Linux

Choose the install directory on your machine by replacing .

Open a Command Prompt as Administrator:

```
set installdir=%HOMEPATH%

mkdir %installdir%
curl -L -o %installdir%\wordslab-notebooks.zip https://github.com/wordslab-org/wordslab-notebooks/archive/refs/heads/main.zip
tar -x -f %installdir%\wordslab-notebooks.zip -C %installdir%
del %installdir%\wordslab-notebooks.zip
ren %installdir%\wordslab-notebooks-main wordslab-notebooks

cd %installdir%\wordslab-notebooks\install\windows-linux
1_install-or-update-windows-subsystem-for-linux.bat
```

Reboot if necessary.

# Step 2: Create a linux virtual machine with Jupyterlab 4 and Pytorch 2.2

Open a Command Prompt:

```
cd %installdir%\wordslab-notebooks\install\windows-linux
2_create-linux-virtual-machine.bat
```

# Step3: Start Jupyterlab and initialize a project

Open a Command Prompt:

```
cd %installdir%\wordslab-notebooks
start-wordslab-notebooks.bat
```

Open your browser to navigate to the following URL: [http:127.0.0.1:8888](http:127.0.0.1:8888).

1. Initialize a Github project.

2. Open a Terminal then execute the following command:

```
create-workspace-project https://github.com/your-org/your-repo.git
```

3. Navigate to the directory named 'your-repo', and open a notebook with the kernel named 'your-repo'.
