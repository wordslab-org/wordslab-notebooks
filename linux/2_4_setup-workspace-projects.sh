#!/bin/bash

# Copy scripts to create one virtual python environment and one ipython kernel per project in the wordslab workspace

cp ../projects/create-workspace-project $UV_INSTALL_DIR/create-workspace-project
chmod u+x $UV_INSTALL_DIR/create-workspace-project

cp ../projects/activate-workspace-project $UV_INSTALL_DIR/activate-workspace-project
chmod u+x $UV_INSTALL_DIR/activate-workspace-project

cp ../projects/delete-workspace-project $UV_INSTALL_DIR/delete-workspace-project
chmod u+x $UV_INSTALL_DIR/delete-workspace-project
