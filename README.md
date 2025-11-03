# Simple Chat Stack

Run Open WebUI with LiteLLM on K3s with Terraform

### Example of Terraform variables

```tfvars
do_token = ""
ssh_key_fingerprints = []

image = "ubuntu-24-04-x64"
region = "sgp1"

master_size = "s-2vcpu-4gb-amd"
master_count = 1

worker_size = "s-4vcpu-8gb-amd"
worker_count = 2

cf_token = ""
cf_zone_id = ""

dns_records = [
  { type = "A", name = "domain.tld", proxied = true, ttl = 1 },
]
```
