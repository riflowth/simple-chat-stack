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

  user_data   = templatefile("${path.module}/user_data/setup-k3s-master-init.sh", {
    k3s_token = random_password.k3s_token.result
  })
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

  user_data   = templatefile("${path.module}/user_data/setup-k3s-worker.sh", {
    k3s_token     = random_password.k3s_token.result
    k3s_master_ip = digitalocean_droplet.master_init.ipv4_address_private
  })
}
