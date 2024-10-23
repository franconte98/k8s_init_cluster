# Configuration bash scripts for a quick setup of a Kubernetes Cluster (VMs)

The repository contains simple bash files to quickly setup the nodes of a Kubernetes Cluster running on Virtual Machines.

## Specifications and Tools used

` OS Used: ` Ubuntu Server 24.04  

` CRI used: ` Docker

` VM Manager used: ` VM Box

` Interface used: ` k9s

` Network Policy used: ` Weave

## Create the cluster

First of all make sure you clone this (public) repository inside each node of your cluster by running the following command.

```bash
git clone https://github.com/franconte98/k8s_init_cluster.git
```

Inside the repository the are some bash file that allows you to quickly setup a working cluster. You won't even need to setup specific version because it is setup to retreive the latest versions and install them! 

So get ready to follow the next steps.

---

**Step 1 - Initialize EACH node with the basic tools**

You wanna make sure you run the following commands for every single node in the cluster. With this you are gonna make sure that each part of the cluster stays updated with the other ones. 

```bash
chmod +x k8s_init_cluster/Scripts/init.sh
```
```bash
bash -xv ./k8s_init_cluster/Scripts/init.sh INSERT_NODE_IP
```

> [!NOTE]
> As you can see in the last instruction you gotta insert the desired IP of the node for your kubernetes cluster. You can retreive it by using the ```ip a``` command.

---

**Step 2 - Initialize the MASTER node/s**

At this point is ready to be created by initializing the master node/s as well. Run the following commands ONLY in the master node/s.

```bash
chmod +x k8s_init_cluster/Scripts/masterinit.sh
```
```bash
bash -xv ./k8s_init_cluster/Scripts/masterinit.sh INSERT_CONTROL_PLANE_IP
```

> [!NOTE]
> Just like you previously did, in the last instruction you gotta insert the IP, that has to be the very same you used for the init.sh

---

**Step 3 - Join to the master node/s**

Next, to initialize the cluster, we also gotta connect the working nodes to the master ones, and to to that you have to retreive the lastest instruction you got from the masterinit.sh execution. It will look something like the following code.

```bash
kubeadm join 192.168.100.50:6443 --token awfaaw.awdawdawd --discovery-token-ca-cert-hash sha256:1233sfjsjsnfsefiusdbmsivseunf34231 --cri-socket unix:///var/run/cri-dockerd.sock
```

Copy that instructions and use it on each working node.

---

**Step 4 - Initialize weave / MetalLB**

The last step to fully initialize the cluster is to setup a Network Policy for you cluster by using Weave and to setup a IP Address Pool for your load balancers.

Run the following instruction on each node of the cluster to setup the POD CIDR through you Network Policy.

```bash
weave
```

This will make sure that the pods are gonna be placed right inside the Weave Pod Cidr, which by default should be `10.32.0.0/12`

> [!TIP]
> If you don't see any changes in the POD CIDR of the cluster, you might wanna reboot your VMs

Next you wanna setup your IP Address Pool for your Load Balancers. To to that you gotta edit the config file `Config/metallb.yaml` Once you are done, run the following command.

```bash
kubectl apply -f k8s_init_cluster/Config/metallb.yaml
```

At this point your cluster should be fully functional and ready to be used as you desire!

## Manage the cluster

Within the tools installed through the bash files the is k9s, a command line dashboard that allows you to manage your cluster easily. To run k9s run the following command.

```bash
k9s
```

> [!TIP]
> More about k9s in the official documentation: https://k9scli.io/topics/commands/

> [!WARNING]
> Our pods might need to be connected externally to our cluster, and in order to do that we might wanna use a DNS Solution to bypass the resolv.config. Run the following command to do that.
>
> ```kubectl apply -f k8s_init_cluster/Config/dns-config.yaml```

> [!TIP]
> Install brew by running the following code.
> 
> ```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"```
