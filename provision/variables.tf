# For DigitalOcean slugs: https://slugs.do-api.dev/

variable "do_token" {
  type        = string
  description = "DigitalOcean API token"
}

variable "ssh_key_fingerprints" {
  type        = list(string)
  description = "SSH key fingerprints"
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to SSH private key"
}

variable "image" {
  type        = string
  description = "DigitalOcean Droplet image"
  default     = "ubuntu-24-04-x64"
}

variable "region" {
  type        = string
  description = "DigitalOcean Droplet region"
  default     = "sgp1"
}

variable "master_size" {
  type        = string
  description = "DigitalOcean Droplet size of Master node"
}

variable "master_count" {
  type        = number
  description = "Number of Master node"
}

variable "worker_size" {
  type        = string
  description = "DigitalOcean Droplet size of Worker node"
}

variable "worker_count" {
  type        = number
  description = "Number of Worker node"
}

variable "cf_token" {
  type        = string
  description = "Cloudflare API token"
}

variable "cf_zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
}

variable "dns_records" {
  type  = list(object({
    type    = string
    name    = string
    proxied = bool
    ttl     = number
  }))
  description = "List of DNS records"
}
