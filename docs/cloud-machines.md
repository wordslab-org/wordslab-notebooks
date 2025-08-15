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

## Estimating the GPU memory and generation speed

The language model generation speed for a single user is limited by the GPU memory bandwidth.

CPU only - Intel Core i7 12700H
- gemma3:1b - 10-28 tokens/sec (1.5 GB)

Nvidia RTX 3070 Ti laptop
- gemma3:4b - 85 tokens/sec (5.7 GB)
- gemma3:1b - 160 tokens/sec (1.9 GB)

Nvidia RTX 4090 desktop
- gemma3:27b - 40 tokens/sec (22 GB)
- gemma3:12b - 75 tokens/sec (12 GB)
- gemma3:4b - 150 tokens/sec (6.2 GB)
- gemma3:1b - 265 tokens/sec (1.9 GB)

Nvidia RTX 5090 on Runpod
- gemma3:27b - 61 tokens/sec
- gemma3:12b - 107 tokens/sec
- gemma3:4b - 205 tokens/sec
- gemma3:1b - 322 tokens/sec

Nvidia RTX 4090 desktop - other models
- mistral-small3.1:24b - 50 tokens/sec (26 GB 9%/91% CPU/GPU)
- qwen3:30b - 138 tokens/sec (21 GB)
- qwen3:14b - 75 tokens/sec (12 GB)
- qwen3:8b - 115 tokens /sec (7.5 GB)
- qwen3:4b - 165 tokens /sec (5.2 GB)
- qwen3:1.7b - 265 tokens /sec (2.0 GB)
- qwen3:0.6b - 340 tokens /sec (1.2 GB)

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