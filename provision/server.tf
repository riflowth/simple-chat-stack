resource "random_password" "k3s_token" {
  length  = 32
  special = false
}

resource "digitalocean_droplet" "master_init" {
  name        = "master-1"

  image       = var.image
  region      = var.region
  size        = var.master_size
  ssh_keys    = var.ssh_key_fingerprints
  vpc_uuid    = digitalocean_vpc.k3s_vpc.id
  monitoring  = true
  tags        = [digitalocean_tag.master.id]

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    private_key = file(var.ssh_private_key_path)
  }

  provisioner "remote-exec" {
    # Setup K3s
    inline = [
      "curl -sfL https://get.k3s.io | K3S_TOKEN=${random_password.k3s_token.result} sh -s - --disable traefik --flannel-iface eth1 --tls-san ${self.ipv4_address}",
    ]
  }

  provisioner "local-exec" {
    # Create kube config file to communicate with the cluster
    command = <<-EOT
      scp root@${self.ipv4_address}:/etc/rancher/k3s/k3s.yaml ./../kubeconfig
      sed -i "" "s/127.0.0.1/${self.ipv4_address}/g" ./../kubeconfig
    EOT
  }
}

# TODO: support multiple master node (need lb/ccm)
# resource "digitalocean_droplet" "master" {
#   count       = var.master_count - 1
#   name        = "master-${1 + (count.index + 1)}" # 1 init + master count
  
#   image       = var.image
#   region      = var.region
#   size        = var.master_size
#   ssh_keys    = var.ssh_key_fingerprints
#   vpc_uuid    = digitalocean_vpc.k3s_vpc.id
#   monitoring  = true
#   tags        = [digitalocean_tag.master.id]

#   depends_on  = [digitalocean_droplet.master_init]
# }

resource "digitalocean_droplet" "worker" {
  count       = var.worker_count
  name        = "worker-${count.index + 1}"

  image       = var.image
  region      = var.region
  size        = var.worker_size
  ssh_keys    = var.ssh_key_fingerprints
  vpc_uuid    = digitalocean_vpc.k3s_vpc.id
  monitoring  = true
  tags        = [digitalocean_tag.worker.id]

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    private_key = file(var.ssh_private_key_path)
  }

  provisioner "remote-exec" {
    # Setup K3s
    inline = [
      "curl -sfL https://get.k3s.io | K3S_TOKEN=${random_password.k3s_token.result} K3S_URL=https://${digitalocean_droplet.master_init.ipv4_address}:6443 sh -s - --flannel-iface eth1",
    ]
  }

  provisioner "local-exec" {
    command = "kubectl label ${self.name} node-role.kubernetes.io/worker=true"
  }
}
