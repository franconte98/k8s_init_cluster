#!/bin/bash

### Install Calico in your system right within your cluster
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml;

### Install the tool calicoctl and set it based off your cluster [Retreive latest]
###VER_CALICO_LATEST=$(curl --silent -qI https://github.com/projectcalico/calico/releases/latest | awk -F '/' '/^location/ {print  substr($NF, 1, length($NF)-1)}'); 
VER_CALICO_MATCH=$(curl --silent -qI https://docs.projectcalico.org/manifests/calico.yaml | awk -F '/' '/^location/' | grep -o -P '(?<=archive/).*(?=/manifests/calico.yaml)');
curl -L https://github.com/projectcalico/calico/releases/download/$VER_CALICO_MATCH/calicoctl-linux-amd64 -o calicoctl;
chmod +x calicoctl;
sudo mv calicoctl /usr/local/bin;
sudo mkdir /etc/calico;
sudo mv k8s_init_cluster/Config/calicoctl.cfg /etc/calico/;

### Check installation and configuration of calico && calicoctl
calicoctl version;
calicoctl get nodes;
calicoctl node status;
sudo systemctl daemon-reload;
sudo systemctl restart cri-docker.service;