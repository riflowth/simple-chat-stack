#!/bin/bash

set -e

curl -sfL https://get.k3s.io | K3S_TOKEN=${k3s_token} K3S_URL=https://${k3s_master_ip}:6443 sh -s - \
  --flannel-iface eth1

kubectl wait --for=create node $(hostname) --timeout=15s
kubectl wait --for=condition=ready node $(hostname) --timeout=15s

# https://github.com/k3s-io/k3s/issues/1289
kubectl label $(hostname) node-role.kubernetes.io/worker=true
