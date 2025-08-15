# Reting a GPU machine in the cloud

## Choosing a GPU to run a generative AI application 

Quick tip: choose a RTX 6000 Ada, or A5000 if you want the cheapest option.

Criteria 1 : make sure your model AND your task fits in the GPU memory (VRAM) 
- as a rule of thumb for inference : plan for model weights size +50%
- as a rule of thumb for full training : plan for 4 times the model weights size

Example memory sizes for inference 
- 8 GB - llama 3.1 8 gb q4km
- 16 GB - qwen 3 14b q4km
- 24 GB - mistral-small 24b q4km
- 48 GB - qwen 3 32b fp8
- 80 GB - llama 3.3 70b q4km

Criteria 2 : understand if your bottleneck will be the memory bandwidth or compute capacity of the GPU
- as a rule of thumb: if there is a single user or if you run queries one by one, you will be limited by the memory bandwidth 
- if there are many simultaneous users of if you can group requests by big batches, you will be limited by the compute capacity 

## Estimating the storage size

Quick tip: start with 100 GB.

With Runpod and JarvisLabs you can alway extend your disk space later.

With Vast.ai, you have to choose a fixed disk size for the duration of your rent.

You can never shrink a disk to a smaller size?

Storage size for workspace : depends on your projects 
- space for your code and librairies: sould be small, except if you install a specific pytorch version which can require several gb disk space
- space for your local data: can be big of your work with images and video, or with huge amounts of text 
- space for local models : only if you plan to train or fine-tune your own models

Note that
- Huggingface datasets will be downloaded in the models directory
- all the model weights downloaded from internet repositories are stored in the models directory 

Storage size for models : total size of all the models and datasets you will download from internet repositories 
- model in 4 bits precision: 10 billion parameters = 5 GB
- model in 8 bits precision: 10 billion parameters = 10 GB
- model in 16 bits precision: 10 billion parameters = 20 GB
- note that of you want to test a selection of Large Language Models, your models directory can get pretty large quickly
