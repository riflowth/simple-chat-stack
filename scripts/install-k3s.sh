set -e

# Note: to uninstall run /usr/local/bin/k3s-uninstall.sh
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable=traefik" sh -
cat /etc/rancher/k3s/k3s.yaml
