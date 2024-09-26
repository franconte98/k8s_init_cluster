#!/bin/bash

Latest_Version_Pause=$(kubectl get nodes -o json | jq -r '.items[].status.images' | grep -o -P '(?<=registry.k8s.io/pause:).*(?=")' | sort | head -1);

sudo systemctl daemon-reload
sudo systemctl restart cri-docker.service