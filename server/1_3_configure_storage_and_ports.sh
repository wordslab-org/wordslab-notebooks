workspace_root=$1
models_root=$2

echo "export WORKSPACE_DIR=$1workspace" >> ~/wordslab-notebooks-environment.sh
echo "export MODELS_DIR=$2models" >> ~/wordslab-notebooks-environment.sh

echo "export JUPYTERLAB_PORT=8888" >> ~/wordslab-notebooks-environment.sh
echo "export GRADIO_PORT=7860" >> ~/wordslab-notebooks-environment.sh
echo "export FASTAPI_PORT=8000" >> ~/wordslab-notebooks-environment.sh
echo "export VLLM_PORT=8000" >> ~/wordslab-notebooks-environment.sh
echo "export ARGILLA_PORT=6900" >> ~/wordslab-notebooks-environment.sh
echo "export OPENWEBUI_PORT=8080" >> ~/wordslab-notebooks-environment.sh
echo "export VSCODE_PORT=8081" >>~/wordslab-notebooks-environment.sh