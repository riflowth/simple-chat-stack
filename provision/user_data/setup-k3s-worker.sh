#!/bin/bash

curl -sfL https://get.k3s.io | K3S_TOKEN=${k3s_token} K3S_URL=https://${k3s_master_ip}:6443 sh -s -
