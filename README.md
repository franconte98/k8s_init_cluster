# Configuration file for quick setup of a Kubernetes Node (Bare Metal)

The repository contains simple bash files to setup quickly the nodes of a Kubernetes Cluster running on a Linux Distro. 

## Usage

Run as an administrator and exec the following commands.

```bash
git clone https://github.com/franconte98/init_kubernetes_cluster_bare_metal.git
```

```bash
chmod +x init_kubernetes_cluster_bare_metal/Scripts/init.sh
```
```bash
chmod +x init_kubernetes_cluster_bare_metal/Scripts/masterinit.sh
```
The previous command gives the permits to run the file to the OS. Read the file before you run it though.

```bash
bash -xv ./init_kubernetes_cluster_bare_metal/Scripts/init.sh
```

ONLY FOR THE MASTER NODE RUN WITH THE FOLLOWING INSTRUCTION.

```bash
bash -xv ./init_kubernetes_cluster_bare_metal/Scripts/masterinit.sh INSERT_CONTROL_PLANE_IP INSERT_CIDR_PODS
```

## Specifications

` OS Used: ` Ubuntu Server 24.04  
` Cri-Socket used: ` cri-dockerd.sock
` VM Manager used: ` VM Box
` Network Policy: ` Weave

