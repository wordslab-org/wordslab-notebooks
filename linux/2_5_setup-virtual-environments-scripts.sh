#!/bin/bash

# Copy scripts to create one virtual python environment and one ipython kernel per project in the wordslab workspace

cp ./create-workspace-project $WORDSLAB_NOTEBOOKS_ENV/bin/create-workspace-project
chmod u+x $WORDSLAB_NOTEBOOKS_ENV/bin/create-workspace-project
cp ./delete-workspace-project $WORDSLAB_NOTEBOOKS_ENV/bin/activate-workspace-project
chmod u+x $WORDSLAB_NOTEBOOKS_ENV/bin/activate-workspace-project
cp ./delete-workspace-project $WORDSLAB_NOTEBOOKS_ENV/bin/delete-workspace-project
chmod u+x $WORDSLAB_NOTEBOOKS_ENV/bin/delete-workspace-project

# Create a first workspace project with tutorials for wordslab notebooks

create-workspace-project https://github.com/wordslab-org/wordslab-notebooks-tutorials.git