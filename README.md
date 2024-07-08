# Configuration file for quick setup of a Kubernetes Node (Bare Metal)

The repository contains a simple init.sh file that allows to setup quickly the nodes of a Kubernetes Cluster running on a Linux Distro. 

## Usage

```bash
chmod +x kubernetes_scripts_ubuntu_cluster/init.sh
```
The previous command gives the permits to run the file to the OS. Read the file before you run it though.

```bash
bash -xv kubernetes_scripts_ubuntu_cluster/init.sh
```

## Specifications

` OS Used: ` Ubuntu Server 24.04

` Cri-Socket used: ` cri-dockerd.sock

` VM Manager used: ` VM Box
