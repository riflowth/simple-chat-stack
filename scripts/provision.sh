set -e

terraform -chdir=provision init
terraform -chdir=provision apply -auto-approve
