resource "digitalocean_project" "k3s_cluster" {
  name = "k3s-cluster"
}

resource "digitalocean_tag" "master" {
  name = "master"
}

resource "digitalocean_tag" "worker" {
  name = "worker"
}

resource "digitalocean_project_resources" "master_init" {
  project   = digitalocean_project.k3s_cluster.id
  resources = [digitalocean_droplet.master_init.urn]
}

# TODO: support multiple master node (need lb/ccm)
# resource "digitalocean_project_resources" "master" {
#   count     = var.master_count - 1
#   project   = digitalocean_project.k3s_cluster.id
#   resources = [digitalocean_droplet.master[count.index].urn]
# }

resource "digitalocean_project_resources" "worker" {
  count     = var.worker_count
  project   = digitalocean_project.k3s_cluster.id
  resources = [digitalocean_droplet.worker[count.index].urn]
}
