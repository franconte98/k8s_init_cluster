# Configuration file for quick setup of a Kubernetes Node (Bare Metal)

The repository contains a simple init.sh file that allows to setup quickly the nodes of a Kubernetes Cluster running on a Linux Distro. 

## Usage

Run as an administrator and exec the following commands.

```bash
git clone https://github.com/franconte98/kubernetes_scripts_ubuntu_cluster.git
```

```bash
chmod +x kubernetes_scripts_ubuntu_cluster/Scripts/init.sh
```
```bash
chmod +x kubernetes_scripts_ubuntu_cluster/Scripts/masterinit.sh
```
The previous command gives the permits to run the file to the OS. Read the file before you run it though.

```bash
bash -xv ./kubernetes_scripts_ubuntu_cluster/Scripts/init.sh
```

ONLY FOR THE MASTER NODE RUN WITH THE FOLLOWING INSTRUCTION.

```bash
bash -xv ./kubernetes_scripts_ubuntu_cluster/Scripts/masterinit.sh
```

## Specifications

` OS Used: ` Ubuntu Server 24.04

` Cri-Socket used: ` cri-dockerd.sock

` VM Manager used: ` VM Box
