./1_1_install-ubuntu-packages.sh
./1_3_configure_storage_and_ports.sh /home /home/models
source ~/wordslab-notebooks-environment.sh

cp 2_1_activate-python-envmanager_on_jarvislab_ai.sh ~/.bashrc
source ~/.bashrc
conda config --append channels conda-forge
./2_3_install_datascience_libs.sh
source ~/wordslab-notebooks-environment.sh
./2_4_setup_virtual_environments_scripts.sh

./3_1_configure-jupyterlab.sh
source ~/wordslab-notebooks-environment.sh
./3_3_configure_jupyterlab_resources_monitoring.sh
./3_4_install_vscode_server.sh

echo 'source ~/wordslab-notebooks-environment.sh' >> ~/.bashrc
echo 'cd $WORKSPACE_DIR' >> ~/.bashrc
./4_start_on_jarvislabs_ai.sh
