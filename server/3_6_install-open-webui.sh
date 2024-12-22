conda create -y --name open-webui-2024-12 python==3.11.11
conda activate open-webui-2024-12

pip install open-webui==0.4.8

mkdir $WORKSPACE_DIR/open-webui
mkdir $WORKSPACE_DIR/open-webui/functions
mkdir $WORKSPACE_DIR/open-webui/tools

conda deactivate
