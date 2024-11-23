conda install -y nbdev=2.3.31

mkdir -p $WORKSPACE_DIR

echo 'export JUPYTER_CONFIG_DIR=$WORKSPACE_DIR/.jupyter/etc/jupyter' >> ~/wordslab-notebooks-environment.sh
echo 'export JUPYTER_DATA_DIR=$WORKSPACE_DIR/.jupyter/share/jupyter' >> ~/wordslab-notebooks-environment.sh
echo 'export JUPYTER_RUNTIME_DIR=$WORKSPACE_DIR/.jupyter/share/jupyter/runtime' >> ~/wordslab-notebooks-environment.sh
echo 'export JUPYTERLAB_SETTINGS_DIR=$WORKSPACE_DIR/.jupyter/lab/user-settings' >> ~/wordslab-notebooks-environment.sh
echo 'export JUPYTERLAB_WORKSPACES_DIR=$WORKSPACE_DIR/.jupyter/lab/workspaces' >> ~/wordslab-notebooks-environment.sh
