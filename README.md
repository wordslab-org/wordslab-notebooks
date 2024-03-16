# wordslab-notebooks
Simple procedures and scripts to initialize a Jupyterlab workspace with GPU access for AI workloads

# Windows subsystem for Linux

Open cmd as administrator:

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

Open cmd:

```
cd %installdir%\wordslab-notebooks\install\windows-linux
2_create-minimal-linux-virtual-machine.bat
```

