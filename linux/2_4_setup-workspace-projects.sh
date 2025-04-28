#!/bin/bash

# Copy scripts to create one virtual python environment and one ipython kernel per project in the wordslab workspace

cp ./2_4_create-workspace-project $UV_INSTALL_DIR/create-workspace-project
chmod u+x $UV_INSTALL_DIR/create-workspace-project

cp ./2_4_activate-workspace-project $UV_INSTALL_DIR/activate-workspace-project
chmod u+x $UV_INSTALL_DIR/activate-workspace-project

cp ./2_4_delete-workspace-project $UV_INSTALL_DIR/delete-workspace-project
chmod u+x $UV_INSTALL_DIR/delete-workspace-project
