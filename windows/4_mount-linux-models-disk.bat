REM Check if a separate disk was initialized to store the models

wsl -d wordslab-notebooks-models -- : >nul
if %errorlevel% equ 0 (
    wsl -d wordslab-notebooks-models -- mkdir -p /mnt/wsl/wordslab-notebooks-models
    wsl -d wordslab-notebooks-models -- mount --bind /home/models /mnt/wsl/wordslab-notebooks-models
    wsl -d %name% -- mount --bind /mnt/wsl/wordslab-notebooks-models /home/models
)