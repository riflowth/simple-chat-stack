set -e

terraform -chdir=provision apply -auto-approve
terraform -chdir=provision output -json > ./provision-output.json

master_ip=$(jq -r '.cluster_summary.value.masters[0].public_ip' provision-output.json)

scp root@${master_ip}:/etc/rancher/k3s/k3s.yaml ./kubeconfig
sed -i "" "s/127.0.0.1/${master_ip}/g" ./kubeconfig
export KUBECONFIG=kubeconfig

export $(grep -v '^#' .env | xargs)

helmfile apply -f . -l install-stage=pre
helmfile apply -f . -l install-stage=db
helmfile apply -f . -l install-stage=proxy
helmfile apply -f . -l install-stage=app
