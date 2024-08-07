# Configuration bash scripts for a quick setup of a Kubernetes Cluster (VMs)

The repository contains simple bash files to quickly setup the nodes of a Kubernetes Cluster running on Virtual Machines.

## Specifications / Tool used

` OS Used: ` Ubuntu Server 24.04  

` CRI used: ` Docker

` VM Manager used: ` VM Box

` Network Policy: ` Weave

` Interface used: ` k9s

## Usage

Run as an administrator and exec the following commands.

⚠️ These commands gives the permits to run the file to the OS. Therefore read them!

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

---

At this point we gotta config our metalLB through a config file that define for us a address pool. That's why we are gonna define it inside our Config/metallb.yaml and then run the following command.

```bash
kubectl apply -f k8s_init_cluster/Config/metallb.yaml
```

From the master node/s we can control the whole cluster by using a tool called k9s. In order to use it just run the following simple command.

```bash
k9s
```
