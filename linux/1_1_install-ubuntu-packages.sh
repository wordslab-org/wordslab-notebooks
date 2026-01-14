#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Install essential commands to download and edit files, build and version code, monitor the machine, resolve network issues, and manage multimedia files

apt update
apt install --yes sudo apt-utils locales 
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
apt install --yes less vim nano tmux screen
apt install --yes ca-certificates curl wget unzip zstd openssh-client
apt install --yes htop nvtop iputils-ping net-tools traceroute
apt install --yes git git-lfs
apt install --yes build-essential cmake
apt install --yes ffmpeg

# Uncomment the line below if you want to generate PDF / HTML versions of your notebooks
# apt install fonts-liberation pandoc texlive-xetex texlive-fonts-recommended texlive-plain-generic
