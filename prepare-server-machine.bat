@echo off
set "tarfile="
for %%f in ("..\secrets\*.tar") do (
    set "tarfile=%%~nxf"
)

if defined tarfile (
    echo Installing secrets files on the server machine:
    wsl -d wordslab-notebooks-workspace -- sh -c "mkdir -p /home/workspace/.secrets && cp ../secrets/%tarfile% /home/workspace/.secrets && cd /home/workspace/.secrets && tar -xvf %tarfile%"
) else (
    echo You first need to copy the .tar file of the secrets generated on the client machine to the ..\secrets directory.
)
