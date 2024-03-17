cd ~
curl -LO --no-progress-meter https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

bash Miniconda3-*.sh -b
~/miniconda3/bin/conda init bash

rm Miniconda3-latest-Linux-x86_64.sh
