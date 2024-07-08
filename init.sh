#!/bin/bash
while true; do
    ls;
    swapoff -a;
    sudo su;
    cd ..;
    cd ..;
    sed -i '/[/]swap.img/ s/^/#/' /etc/fstab;
    exit;

    sudo apt install net-tools;
    sudo apt-get update;
    sudo apt-get install -y apt-transport-https ca-certificates curl gpg;
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg;
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list;
    sudo apt-get update;
    sudo apt-get install -y kubelet kubeadm kubectl;
    sudo apt-mark hold kubelet kubeadm kubectl;
    sudo apt-mark hold kubelet kubeadm kubectl;
    wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.14/cri-dockerd-0.3.14.amd64.tgz;
    tar -xvf cri-dockerd-0.3.14.amd64.tgz;
    sudo su;
    sudo apt install docker.io -y;
    systemctl start docker;
    systemctl enable docker;
    cd cri-dockerd;
    mkdir -p /usr/local/bin;
    install -o root -g root -m 0755 ./cri-dockerd /usr/local/bin/cri-dockerd;

    systemctl daemon-reload;
    systemctl enable cri-docker.service;
    systemctl enable --now cri-docker.socket;

    sysctl --system;
    sudo systemctl enable kubelet;
    sudo kubeadm config images pull --cri-socket /var/run/cri-dockerd.sock;
done

sudo tee /etc/systemd/system/cri-docker.service <<-EOF
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

echo "memory swapoff";
    sudo modprobe overlay;
    sudo modprobe br_netfilter;
    sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    net.ipv4.ip_forward = 1
EOF