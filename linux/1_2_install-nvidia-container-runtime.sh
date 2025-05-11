#!/bin/bash

if [ ! -f /etc/apt/sources.list.d/nvidia-container-toolkit.list ]; then

    # Add nvidia repository to Apt sources:
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
        tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
fi

# Install nvidia container runtime
apt-get update
apt-get install -y nvidia-container-toolkit

# Configure Docker to use nvidia container runtime
nvidia-ctk runtime configure --runtime=docker
