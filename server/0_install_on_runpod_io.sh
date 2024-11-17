cpu=$1
condaenv="pytorch-2.4"

./1_1_install-ubuntu-packages.sh
./1_2_install_docker.sh
if [ "$cpu_flag" == "false" ]; then
    ./1_2_install_nvidia_container_runtime.sh
fi
./1_3_configure_storage_and_ports.sh
./2_1_install-python-envmanager.sh
if [ "$cpu_flag" == "true" ]; then
    ./2_2_install-pytorch-cpu.sh $condaenv
else
    ./2_2_install-pytorch-cuda.sh $condaenv
fi
./2_3_install_datascience_libs.sh
./2_4_setup_virtual_environments_scripts.sh
./3_1_install-jupyterlab.sh
./3_2_configure_jupyterlab_git_support.sh
./3_3_configure_jupyterlab_resources_monitoring.sh
./3_4_install_vscode_server.sh