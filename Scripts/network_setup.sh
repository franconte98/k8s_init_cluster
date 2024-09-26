#!/bin/bash

### Install Weave as a Network Plugin
VER_LATEST_WEAVE=$(curl --silent -qI https://github.com/weaveworks/weave/releases/latest | awk -F '/' '/^location/ {print  substr($NF, 1, length($NF)-1)}');
kubectl apply -f https://github.com/weaveworks/weave/releases/download/$VER_LATEST_WEAVE/weave-daemonset-k8s.yaml;

### Reload the cri-docker
sudo systemctl daemon-reload;
sudo systemctl restart cri-docker.service;