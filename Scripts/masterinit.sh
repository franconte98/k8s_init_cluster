#!/bin/bash
### --pod-network-cidr="$2"
sudo kubeadm init --upload-certs --control-plane-endpoint="$1" --apiserver-advertise-address="$1" --ignore-preflight-errors=all --cri-socket unix:///var/run/cri-dockerd.sock;
mkdir -p $HOME/.kube;
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config;
sudo chown $(id -u):$(id -g) $HOME/.kube/config;
kubectl create namespace tigera-operator;
helm install calico projectcalico/tigera-operator --version v3.28.1 --namespace tigera-operator;

### Append strictARP: true
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system;
### 
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system;

helm repo add metallb https://metallb.github.io/metallb;
kubectl create namespace metallb-system;
helm install metallb metallb/metallb --set crds.validationFailurePolicy=Ignore -n metallb-system;

sudo snap install k9s;

kubeadm token create --print-join-command;