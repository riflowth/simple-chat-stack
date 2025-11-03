locals {
  master_init = [
    {
      id          = digitalocean_droplet.master_init.id
      name        = digitalocean_droplet.master_init.name
      public_ip   = digitalocean_droplet.master_init.ipv4_address
      private_ip  = digitalocean_droplet.master_init.ipv4_address_private
    }
  ]

  # TODO: support multiple master node (need lb/ccm)
  masters = [
    # for key, server in digitalocean_droplet.master :
    # {
    #   id          = server.id
    #   name        = server.name
    #   public_ip   = server.ipv4_address
    #   private_ip  = server.ipv4_address_private
    # }
  ]

  all_masters = concat(local.master_init, local.masters)

  workers = [
    for key, server in digitalocean_droplet.worker :
    {
      id          = server.id
      name        = server.name
      public_ip   = server.ipv4_address
      private_ip  = server.ipv4_address_private
    }
  ]
}
