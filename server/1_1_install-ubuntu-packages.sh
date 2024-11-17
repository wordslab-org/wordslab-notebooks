export DEBIAN_FRONTEND=noninteractive

apt update
apt install --yes sudo locales ca-certificates curl wget unzip less vim tmux screen git git-lfs htop nvtop iputils-ping net-tools traceroute openssh-client build-essential cmake ffmpeg

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
echo "export LANG=en_US.UTF-8" >> ~/.bashrc
echo "export LANGUAGE=en_US.UTF-8" >> ~/.bashrc

# Uncomment the line below if you want to generate PDF / HTML versions of your notebooks
# apt install fonts-liberation pandoc texlive-xetex texlive-fonts-recommended texlive-plain-generic