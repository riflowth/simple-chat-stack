set -e

export KUBECONFIG=kubeconfig
export $(grep -v '^#' .env | xargs)

helmfile apply -f . -l install-stage=pre
helmfile apply -f . -l install-stage=db
helmfile apply -f . -l install-stage=proxy
helmfile apply -f . -l install-stage=app
