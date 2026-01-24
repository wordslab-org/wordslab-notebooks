#!/bin/bash

# Donwload and install uv, the modern Python package manager
mkdir -p $UV_INSTALL_DIR
# ----
# Pin uv to version 0.9.24
# Version 0.9.25 and 0.9.26 create a deadlock when executing "uv python install" in WSL:
# > DEBUG Acquired shared lock for `/home/python`
# > INFO Waiting to acquire exclusive lock for `/home/python` at `/home/python/.lock`
# This is what’s happening internally:
# 1. uv opens /home/python/.lock
# 2. It takes a shared (read) lock so it can inspect what’s installed
# 3. It decides it needs to install Python → needs a write (exclusive) lock
# 4. It tries to “upgrade” the lock
# 5. On many filesystems, lock upgrade is not atomic → it blocks forever waiting for… itself
curl -LsSf https://astral.sh/uv/0.9.24/install.sh | sh
# ----
source $UV_INSTALL_DIR/env

# Install Python version
uv python install 3.12.12
