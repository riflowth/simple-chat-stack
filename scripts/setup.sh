set -e

source .env

helmfile apply -f . -l install-stage=pre
helmfile apply -f . -l install-stage=db
helmfile apply -f . -l install-stage=proxy
helmfile apply -f . -l install-stage=app
