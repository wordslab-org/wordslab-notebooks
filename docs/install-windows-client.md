# Install wordslab on a Windows machine used as a client to access a remote wordslab server machine

In this setup, we need to install wordslab-notebooks on two machines:
- a powerful remote machine is used as a server to run the wordslab-notebooks applications  
- a lightweight local machine is used as a client to access the wordslab-notebooks applications through a browser

1. Install the server machine

First, install the server machine using the commands documented in the other installation sections.

**On the server machine**, get the server machine IP address or DNS domain name.

- if the remote machine is a local PC, use one of the commands below

```shell
# Windows
ipconfig

# Linux
ifconfig
```

- if the remote machine is hosted by a cloud provider, and the cloud provider **already exposes** the web applications running on it through a public https URL: you don't need to do anything

- if the remote machine is hosted by a cloud provider, but the cloud provider **doesn't expose** the web application running on it through a public https URL: go to the cloud provider website, display the connection options to the running virtual machine, copy the external IP or the dns domain name given to access web applications

2. Prepare the client machine

Option 1: **on the client machine**, if wordslab-notebooks is **not yet installed**, open a terminal and run the following command

```shell
set "WORDSLAB_WINDOWS_HOME=C:\wordslab" && call set "WORDSLAB_VERSION=2025-05" && call curl -sSL https://raw.githubusercontent.com/wordslab-org/wordslab-notebooks/refs/tags/%WORDSLAB_VERSION%/prepare-client-machine.bat -o "%temp%\prepare-client-machine.bat" && call "%temp%\prepare-client-machine.bat"
```

Option 2: **on the client machine**, if wordslab-notebooks is **already installed**, open a terminal and run the following command

```shell
set "WORDSLAB_WINDOWS_HOME=C:\wordslab" && call set "WORDSLAB_VERSION=2025-05" && call cd "%WORDSLAB_WINDOWS_HOME%\wordslab-notebooks-%WORDSLAB_VERSION%" && call prepare-client-machine.bat
```

Before executing theses commands, you can personalize the install directory and the wordslab version
- WORDSLAB_WINDOWS_HOME : install directory
- WORDSLAB_VERSION : wonrdslab-notebooks release to install

Note: you will have to accept to install a new certificate authority in your browser trusted store.

3. Generate secrets for the server machine

**On the client machine**, generate a tar file containing secrets for a specific server machine

```shell
set "WORDSLAB_WINDOWS_HOME=C:\wordslab" && call set "WORDSLAB_VERSION=2025-05" && call cd "%WORDSLAB_WINDOWS_HOME%\wordslab-notebooks-%WORDSLAB_VERSION%" && call prepare-server-secrets.bat
```

The script will ask you to input
- a public IP or DNS domain name for your server machine
- an optional password (which you can leave empty) to limit access to JupyterLab and Visual Studio Code on the remote machine

This script will generate a secrets file like

```
%WORDSLAB_WINDOWS_HOME%\secrets\wordslab-server-192.168.1.28-secrets.tar
```

IMPORTANT: you will need to regenerate this secrets file each time the server IP address or DNS name changes.

4. Transfer the secrets tar file to the server machine:

**On a Windows server machine**
- copy the tar file in the %WORDSLAB_WINDOWS_HOME%\secrets directory

**On a Linux server machine**
- copy the tar file in the $WORDSLAB_WORKSPACE/.secrets directory
- cd $WORDSLAB_WORKSPACE/.secrets directory
- tar -xvf [tar file]

5. Prepare the server machine

**On a Windows server machine**

```shell
set "WORDSLAB_WINDOWS_HOME=C:\wordslab" && call set "WORDSLAB_VERSION=2025-05" && call cd "%WORDSLAB_WINDOWS_HOME%\wordslab-notebooks-%WORDSLAB_VERSION%" && call prepare-server-machine.bat
```

**On a Linux server machine**

Nothing to do, the machine is ready.

6. Start the server machine

Then, start the server machine using the commands documented in the other installation sections.

The startup script will automatically detect the secrets you installed on the server machine:
- the web applications will be exposed with the https protocol
- optionally, a password will be required for Jupyterlab and Visual Studio Code

## Optional - Enable other Windows client machines to access the same server machine

Transfer the file %WORDSLAB_WINDOWS_HOME%\secrets\wordslab-client-secrets.tar from the first Windows client machine to the directory %WORDSLAB_WINDOWS_HOME%\secrets on the second Windows client machine.

On the second Windows client machine, execute the commands of the section 

2. Prepare the client machine