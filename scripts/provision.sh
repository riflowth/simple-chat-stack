set -e

terraform -chdir=provision apply -auto-approve

master_ip=$(terraform -chdir=provision output -json | jq -r '.cluster_summary.value.masters[0].public_ip')

scp root@${master_ip}:/etc/rancher/k3s/k3s.yaml ./kubeconfig
sed -i "" "s/127.0.0.1/${master_ip}/g" ./kubeconfig
