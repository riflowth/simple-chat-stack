set -e

master_ip=$(terraform -chdir=provision output -json | jq -r '.cluster_summary.value.masters[0].public_ip')

# Label worker nodes
kubectl get nodes -o name | grep worker | xargs -n1 -I@ kubectl label @ node-role.kubernetes.io/worker=true

# Setup tls-san
k3s_config="tls-san:\n  - ${master_ip}"
echo $k3s_config | ssh root@${master_ip} -T "cat > /etc/rancher/k3s/config.yaml"
ssh root@${master_ip} -T /bin/bash << EOF
  kubectl -n kube-system delete secrets/k3s-serving --ignore-not-found=true
  systemctl restart k3s
EOF

# Create kube config file to communicate with the cluster
scp root@${master_ip}:/etc/rancher/k3s/k3s.yaml ./kubeconfig
sed -i "" "s/127.0.0.1/${master_ip}/g" ./kubeconfig
