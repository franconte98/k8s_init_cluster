#!/bin/bash
sudo kubeadm init --upload-certs --control-plane-endpoint="$1" --pod-network-cidr="$2" --ignore-preflight-errors=all --cri-socket /var/run/cri-dockerd.sock;
mkdir -p $HOME/.kube;
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config;
sudo chown $(id -u):$(id -g) $HOME/.kube/config;
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml;

### Append strictARP: true
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system
### 
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

helm repo add metallb https://metallb.github.io/metallb;
helm install metallb metallb/metallb;
helm upgrade --install metallb  metallb/metallb --create-namespace --namespace metallb-system --set crds.validationFailurePolicy=Ignore --wait

kubeadm token create --print-join-command;