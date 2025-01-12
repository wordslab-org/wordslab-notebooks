# How to delete wordslab-notebooks virtual machines

**!!! WARNING !!!**

If you use the commands below, all the data will be lost **forever**, there is no way to undo: use them at your own risk.

## OS and software installation

> wsl --unregister wordslab-notebooks (if you kep the default name)

or

> wsl --unregister *user specific name* (if you used the --name parameter at installation)

## Shared virtual disks

> wsl --unregister wordslab-notebooks-workspace

> wsl --unregister wordslab-notebooks-models
