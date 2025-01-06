# Source this file in ~/.bashrc to configure the machine shell

# Start in the right Python environment and in the right directory 
source <("$CONDA_DIR/bin/conda" 'shell.bash' 'hook' 2> /dev/null)
conda activate $WORDSLAB_NOTEBOOKS_ENV
cd $WORDSLAB_WORKSPACE
