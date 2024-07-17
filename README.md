# Configuration file for quick setup of a Kubernetes Node (Bare Metal)

The repository contains simple bash files to setup quickly the nodes of a Kubernetes Cluster running on a Linux Distro. 

## Specifications

` OS Used: ` Ubuntu Server 24.04  

` Cri-Socket used: ` cri-dockerd.sock

` VM Manager used: ` VM Box

` Network Policy: ` Weave

## Usage

Run as an administrator and exec the following commands.

⚠️ These commands gives the permits to run the file to the OS. Therefore read the files before you run them!

```bash
git clone https://github.com/franconte98/k8s_init_cluster.git
```

```bash
chmod +x k8s_init_cluster/Scripts/init.sh
```
```bash
chmod +x k8s_init_cluster/Scripts/masterinit.sh
```

Now you can execute them by use the following commands.

Run the following command on each node (both the Master/s and the working ones)
```bash
bash -xv ./k8s_init_cluster/Scripts/init.sh
```

⚠️ USE THE FOLLOWING COMMAND ONLY ON THE MASTER NODE/S

```bash
bash -xv ./k8s_init_cluster/Scripts/masterinit.sh INSERT_CONTROL_PLANE_IP INSERT_CIDR_PODS
```
