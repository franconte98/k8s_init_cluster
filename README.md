# Configuration file for quick setup of a Kubernetes Node (Bare Metal)

The repository contains simple bash files to setup quickly the nodes of a Kubernetes Cluster running on a Linux Distro. 

## Specifications

` OS Used: ` Ubuntu Server 24.04  

` Cri-Socket used: ` cri-dockerd.sock

` VM Manager used: ` VM Box

` Network Policy: ` Weave

## Usage

Run as an administrator and exec the following commands.

⚠️ These commands gives the permits to run the file to the OS. Therefor read the file before you run them!

```bash
git clone https://github.com/franconte98/init_kubernetes_cluster_bare_metal.git
```

```bash
chmod +x init_kubernetes_cluster_bare_metal/Scripts/init.sh
```
```bash
chmod +x init_kubernetes_cluster_bare_metal/Scripts/masterinit.sh
```

Now you can execute them by use the following commands.

Run the following command on each node (both the Master/s and the working ones)
```bash
bash -xv ./init_kubernetes_cluster_bare_metal/Scripts/init.sh
```

⚠️ USE THE FOLLOWING COMMAND ONLY ON THE MASTER NODE/S

```bash
bash -xv ./init_kubernetes_cluster_bare_metal/Scripts/masterinit.sh INSERT_CONTROL_PLANE_IP INSERT_CIDR_PODS
```
