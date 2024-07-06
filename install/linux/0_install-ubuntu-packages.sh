export DEBIAN_FRONTEND=noninteractive

apt update
apt install --yes sudo locales ca-certificates curl wget unzip less vim tmux screen git git-lfs htop nvtop iputils-ping net-tools traceroute openssh-client build-essential cmake ffmpeg

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
echo "export LANG=en_US.UTF-8" >> ~/.bashrc
echo "export LANGUAGE=en_US.UTF-8" >> ~/.bashrc
source ~/.bashrc

# Uncomment the line below if you want to generate PDF / HTML versions of your notebooks
# apt install fonts-liberation pandoc texlive-xetex texlive-fonts-recommended texlive-plain-generic

# Install Docker Engine on Ubuntu
# https://docs.docker.com/engine/install/ubuntu/

# Add Docker's official GPG key:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

# Install the latest version
apt-get install --yes docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
