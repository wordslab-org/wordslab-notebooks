cpu=$1

./1_1_install-ubuntu-packages.sh
./1_2_install_docker.sh
if [ "$cpu" == "false" ]; then
    ./1_2_install_nvidia_container_runtime.sh
fi
./1_3_configure_storage_and_ports.sh /workspace /models
source ~/wordslab-notebooks-environment.sh

./2_1_install-python-envmanager.sh
eval "$('/root/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ "$cpu" == "true" ]; then
    ./2_2_install-pytorch-cpu.sh
else
    ./2_2_install-pytorch-cuda.sh
fi
eval "$(tail -n 1 ~/.bashrc)"
./2_3_install_datascience_libs.sh
source ~/wordslab-notebooks-environment.sh
./2_4_setup_virtual_environments_scripts.sh

./3_1_install-jupyterlab.sh
source ~/wordslab-notebooks-environment.sh
./3_2_configure_jupyterlab_git_support.sh
./3_3_configure_jupyterlab_resources_monitoring.sh
./3_4_install_vscode_server.sh
./3_5_install-ollama-openwebui.sh
./3_6_install-open-webui.sh

echo 'source ~/wordslab-notebooks-environment.sh' >> ~/.bashrc
echo 'cd $WORKSPACE_DIR' >> ~/.bashrc
cp ./4_start_on_windows_subsystem_for_linux.sh ~/start-wordslab-notebooks.sh
chmod u+x ~/start-wordslab-notebooks.sh
