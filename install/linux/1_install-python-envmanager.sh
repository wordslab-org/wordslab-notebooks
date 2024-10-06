cd ~
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"

bash Miniforge3-$(uname)-$(uname -m).sh -b
~/miniforge3/bin/conda init bash

rm  Miniforge3-Linux-x86_64.sh
