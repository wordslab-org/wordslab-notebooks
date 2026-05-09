REM Usage : 5_install-linux-virtual-machine <wsl distribution name>(required) <cpu only?>(required)

REM Note : you can't change WORDSLAB_WORKSPACE or WORDSLAB_MODELS default paths in the WSL virtual machine
REM => this would break 4_mount-linux-virtual-disks.bat

wsl -d %1 -- bash -lc "export WORDSLAB_VERSION=%WORDSLAB_VERSION%; apt update && apt install -y curl unzip && curl -fsSL https://raw.githubusercontent.com/wordslab-org/wordslab-notebooks/refs/tags/%WORDSLAB_VERSION%/install-wordslab-notebooks.sh | bash -s -- %2"
