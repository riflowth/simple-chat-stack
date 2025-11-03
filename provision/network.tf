resource "digitalocean_vpc" "k3s_vpc" {
  name      = "k3s-vpc"
  region    = var.region
  ip_range  = "10.0.0.0/24" 
}

# TODO: support multiple master node (need lb/ccm)
resource "digitalocean_firewall" "k3s_ingress_firewall" {
  name = "k3s-ingress"
  tags = [digitalocean_tag.master.name]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "6443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_firewall" "k3s_firewall" {
  name = "k3s-firewall"
  tags = [digitalocean_tag.master.name, digitalocean_tag.worker.name]

  inbound_rule {
    protocol          = "icmp"
    source_addresses  = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol          = "tcp"
    port_range        = "1-65535"
    source_addresses  = [digitalocean_vpc.k3s_vpc.ip_range]
  }

  inbound_rule {
    protocol          = "udp"
    port_range        = "1-65535"
    source_addresses  = [digitalocean_vpc.k3s_vpc.ip_range]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
