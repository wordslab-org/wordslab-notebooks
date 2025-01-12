REM Mandatory parameter : 4_mount-linux-virtual-disks.bat <wsl distribution name>

wsl -d wordslab-notebooks-workspace -- mkdir -p /mnt/wsl/wordslab-notebooks-workspace
wsl -d wordslab-notebooks-workspace -- mount --bind /home/workspace /mnt/wsl/wordslab-notebooks-workspace
wsl -d %name% -- mkdir -p /home/workspace
wsl -d %name% -- mount --bind /mnt/wsl/wordslab-notebooks-workspace /home/workspace

wsl -d wordslab-notebooks-models -- mkdir -p /mnt/wsl/wordslab-notebooks-models
wsl -d wordslab-notebooks-models -- mount --bind /home/models /mnt/wsl/wordslab-notebooks-models
wsl -d %name% -- mkdir -p /home/models
wsl -d %name% -- mount --bind /mnt/wsl/wordslab-notebooks-models /home/models
