#!/bin/bash
ls;

### Disable Swap in linux
swapoff -a;
sed -i '/[/]swap.img/ s/^/#/' /etc/fstab;

### Get the tools for Logging and Networking on Linux
sudo apt install net-tools;
sudo apt-get update;

### Retreive the latest version of Kubernetes and store it in $VER_K8S_Latest
Version_K8S_Latest="$(curl -sSL https://dl.k8s.io/release/stable.txt)"; 
Version_K8S_Stable=$(echo $Version_K8S_Latest | cut -d '.' -f 1)"."$(echo $Version_K8S_Latest | cut -d '.' -f 2);

### Install Kubernetes components
sudo apt-get install -y apt-transport-https ca-certificates curl gpg;
curl -fsSL https://pkgs.k8s.io/core:/stable:/$Version_K8S_Stable/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg;
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/'$Version_K8S_Stable'/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list;
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null;
sudo apt-get update;
sudo apt-get install -y kubelet kubeadm kubectl;
sudo apt-mark hold kubelet kubeadm kubectl;
sudo apt-get install apt-transport-https --yes;
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list;
sudo apt-get update;

### Install Helm and the Docker CRI [Retreive the latest]
sudo apt-get install helm;
VER_CRI_DOCKER=$(curl --silent -qI https://github.com/Mirantis/cri-dockerd/releases/latest | awk -F '/' '/^location/ {print  substr($NF, 1, length($NF)-1)}'); 
wget https://github.com/Mirantis/cri-dockerd/releases/download/$VER_CRI_DOCKER/cri-dockerd-${VER_CRI_DOCKER#v}.amd64.tgz;
tar -xvf cri-dockerd-${VER_CRI_DOCKER#v}.amd64.tgz;
sudo apt install docker.io -y;
systemctl enable --now docker;
cd cri-dockerd || exit;
mkdir -p /usr/local/bin;
install -o root -g root -m 0755 ./cri-dockerd /usr/local/bin/cri-dockerd;

### Set up the Docker CRI 
sudo tee /etc/systemd/system/cri-docker.service << EOF
[Unit]
Description=CRI Interface for Docker Application Container Engine
Documentation=https://docs.mirantis.com
After=network-online.target firewalld.service docker.service
Wants=network-online.target
Requires=cri-docker.socket
[Service]
Type=notify
ExecStart=/usr/local/bin/cri-dockerd --container-runtime-endpoint fd:// --network-plugin=
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutSec=0
RestartSec=2
Restart=always
StartLimitBurst=3
StartLimitInterval=60s
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
Delegate=yes
KillMode=process
[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/systemd/system/cri-docker.socket << EOF
[Unit]
Description=CRI Docker Socket for the API
PartOf=cri-docker.service
[Socket]
ListenStream=%t/cri-dockerd.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker
[Install]
WantedBy=sockets.target
EOF

systemctl daemon-reload;
systemctl enable cri-docker.service;
systemctl enable --now cri-docker.socket;

echo "memory swapoff";
sudo modprobe overlay;
sudo modprobe br_netfilter;
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

### Install and setup Docker Compose (allow to handle containers, images and volumes through YAMLs) [Retreive the latest]
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker};
mkdir -p $DOCKER_CONFIG/cli-plugins;
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose;
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose;


### Install all the necessary components of K8S Architecture right inside Docker
sysctl --system;
sudo systemctl enable kubelet;
sudo kubeadm config images pull --cri-socket unix:///var/run/cri-dockerd.sock;

### Set Up Internal-IP of the Node
IP_INT=$1;
echo 'KUBELET_EXTRA_ARGS="--node-ip='$IP_INT'"' > /etc/default/kubelet;
systemctl restart kubelet;