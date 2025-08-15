# Choosing a provider to rent a GPU in the cloud 

## Rent or buy?

If you just want to explore and learn AI, or if you work on a side project during your spare time, renting a machine in the cloud only when you need it can be a good option.

In february 2025
- a good pc to run wordslab notebooks with a Nvidia GPU and more than 16 GB vram will cost you at least 3000 $
- renting 100 GB of storage and 10 hours of equivalent GPU time per week in the cloud will cost you 30$ per month
- so you could use a cloud machine for 8 years before you spend as much as a local machine

On the contrary, if you want a machine to work 24/7 on AI, buying your own machine makes more sense
- running the equivalent of a powerful consumer machine in the cloud full time would cost around 700 $ per month
- so buying your own machine would be cheaper after five months only

In this first version, wordslab notebooks supports 3 specialized cloud providers
	- cheaper than Amazon, Microsoft or Google
	- popular and trusted by the community
	- providing a good choice of GPUs
	- offering a good user interface and support 

## Choosing a provider

Each one of these 3 providers has its own strengths and weaknesses

Runpod.io provides secure machines in a dozen datacenters located in different regions of the world
- pros: all the professional GPUs are available, host your data in your geographical zone, FAST network disks
- cons: there is a distinct selection of GPUs in each datacenter, and you can't share data between datacenters, more limited options to swap the GPU attached to your instance

Vast.ai is a marketplace where you can rent machines offered by professionals (secure machines in datacenters) and by individuals (consumer machines at home)
- pros: most comprehensive GPU selection including small consumer models (RTX), cheapest prices
- cons: more complicated to use, security and performance depend of your choice of machine in the marketplace
- note: on unsecure machines, nothing you do is confidential and you can loose your data at any moment

Jarvislabs.ai provides a simple UI to rent secure machines located in a single datacenter in India
- pros: by far the simplest user experience to start, good GPU availability,  very easy to swap the GPU attached to your instance, great support
- cons: limited GPU selection, SLOW network disks, no choice of the region where your data will be hosted 

## Cloud storage and rented machines lifecycle

When renting machines on cloud services, the lifecycle of the storage and compute resources looks like this:

1. You first *create* a virtual machine configuration and give it a name:
- choose machine type
- allocate storage space
- choose operating system and pre-installed software
- choose network config for remote acces

To make this step easier, the cloud providers often provide predefined templates that you can personnalize

This configuration and the storage space (virtual disk) which is allocated at this point is called an "instance". 

It will persist until you explicitly decide to *delete* the instance.

You are usually billed for this persistent storage until you delete it, even while your machine is not running.

2. When you *start* your instance, the cloud provider tries to find a physical machine in its datacenter which is free at the moment and which matches your hardware requirements.

There are no guarantees that such a machine will be available exactly when you need it: you must take this "average GPU availability" criteria into account when you choose a provider and a machine type.

Then the cloud provider links your persistent virtual disk with this physical machine, boots the operating system, starts the preinstalled software, and creates a network route and address that you can use to remotely connect to the machine.

Some cloud providers also allocate temporary storage for the operating system of the instance during this startup process.

If this process is successful, you get a "running instance" in about one minute, and you can then work on it as long as you need.

You are usually billed for each minute you use the physical machine.

3. When you are done with your work, you can *stop* your instance : the physical machine will be freed for other users, and the operating system temporary storage is deleted.

At this point you stop being billed for your GPU.

But your instance virtual disks will persist, keeping your data at hand until you need to *restart* your instance later.

With each cloud provider you get different types of storage:

- with one of the three following lifespans, from the shortest to the longest:
  - run: allocated when a machine is started, erased when a machine is stopped
  - instance: allocated when an instance is created, erased when an instance is deleted
  - account: allocated when you decide, erased when you decide

- with one of the following three levels of accessibility from different machines, from the most restricted to the most flexible:
  - machine: virtual disk accessible from one specific machine only
  - machines pool: virtual disk accessible from a group of machines which all share the same gpu type
  - datacenter: virtual disk accessible from all the machines (with different gpu types) located in the same datacenter 
	
Important: the accessibilty of the storage you choose when you create the instance can then limit your ability to change the type of gpu you want to use each time you restart your instance. 

Only a "datacenter" accessibilty will enable you to change the gpu type between two runs of your instance.

If the cloud provider deploys different types of GPUs in different datacenters, there is no way you can share a virtual disk between two datacenters: this means that you must be carefully select the datacenter where you allocate your persistent storage depending on the type of GPU you will want to use.

Here are the name of the different type of storage provided by the 3 cloud services, their properties, their mount point in the running instance filesystem, and their price:

TO DO

## Usage price simulations - August 2025

100 GB storage - 24 GB Ampere GPU - 10 hours per week

- Runpod: TO DO
- Vasta.ai: TO DO 
- Jarvislabs: TO DO

200 GB storage - 48 GB Ada GPU - 20 hours per week

- Runpod: TO DO
- Vasta.ai: TO DO 
- Jarvislabs: TO DO

300 GB storage - 96 GB Blackwell GPU - 30 hours per week

- Runpod: TO DO
- Vasta.ai: TO DO 
- Jarvislabs: TO DO

500 GB storage - 80 GB Hopper GPU - 50 hours per week

- Runpod: TO DO
- Vasta.ai: TO DO 
- Jarvislabs: TO DO
