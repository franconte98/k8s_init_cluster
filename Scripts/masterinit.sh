#!/bin/bash
sudo kubeadm init --upload-certs --control-plane-endpoint="$1" --apiserver-advertise-address="$1" --ignore-preflight-errors=all --cri-socket unix:///var/run/cri-dockerd.sock;
mkdir -p $HOME/.kube;
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config;
sudo chown $(id -u):$(id -g) $HOME/.kube/config;

### Append strictARP: true
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system;
### 
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system;

### Add MetalLB (Load Balancing in a VMs Cluster)
helm repo add metallb https://metallb.github.io/metallb;
kubectl create namespace metallb-system;
helm install metallb metallb/metallb --set crds.validationFailurePolicy=Ignore -n metallb-system;

### Add k9s (Complete Dashboard accessible from Command Line)
sudo snap install k9s;
sudo ln -s /snap/k9s/current/bin/k9s /snap/bin/;

### Print the instruction to join the cluster from working nodes [Remember to add --cri-socket unix:///var/run/cri-dockerd.sock at the end]
kubeadm token create --print-join-command;