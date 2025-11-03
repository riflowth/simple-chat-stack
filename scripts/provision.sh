set -e

terraform -chdir=provision apply -auto-approve

master_ip=$(terraform -chdir=provision output -json | jq -r '.cluster_summary.value.masters[0].public_ip')

# Setup tls-san
k3s_config="tls-san:\n  - ${master_ip}"
echo $k3s_config | ssh root@${master_ip} -T "cat > /etc/rancher/k3s/config.yaml"
kubectl -n kube-system delete secrets/k3s-serving
ssh root@${master_ip} -T "systemctl restart k3s"

# Create kube config file to communicate with the cluster
scp root@${master_ip}:/etc/rancher/k3s/k3s.yaml ./kubeconfig
sed -i "" "s/127.0.0.1/${master_ip}/g" ./kubeconfig
