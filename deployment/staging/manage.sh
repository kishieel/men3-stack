#!/bin/bash

readonly GREEN='\033[0;32m'
readonly NC='\033[0m'

function help() {
    echo -e "Usage: $0 <command>"
    echo -e
    echo -e "Commands:"
    echo -e "  ${GREEN}help${NC}       Show this help message"
    echo -e "  ${GREEN}ip${NC}         Get the public IP address of the virtual machine"
    echo -e "  ${GREEN}provision${NC}  Provision the staging environment"
    echo -e "  ${GREEN}destroy${NC}    Destroy the staging environment"
    echo -e "  ${GREEN}connect${NC}    Connect to the virtual machine"
    echo -e "  ${GREEN}deploy${NC}     Deploy the application to the staging environment"
}

function provision() {
  terraform -chdir=terraform apply -auto-approve -var-file=staging.tfvars
}

function destroy() {
  terraform -chdir=terraform destroy -auto-approve -var-file=staging.tfvars
}

function get_ec2_public_ip() {
  terraform -chdir=terraform output -json | jq -r '.public_ip.value'
}

function get_ec2_private_key() {
  terraform -chdir=terraform output -json | jq -r '.private_key.value'
}

function ssh_agent() {
  local private_key; private_key=$(get_ec2_private_key)
  eval "$(ssh-agent -s)"
  ssh-add <(echo -e "$private_key\n")
}

function connect() {
  ssh_agent

  local public_ip; public_ip=$(get_ec2_public_ip)
  ssh -A -tt ec2-user@"$public_ip"
}

function deploy() {
  source .env

  if [[ -z "$GHCR_USERNAME" || -z "$GHCR_PASSWORD" ]]; then
    echo "Please set the GHCR_USERNAME and GHCR_PASSWORD environment variables"
    exit 1
  fi

  ssh_agent

  local public_ip; public_ip=$(get_ec2_public_ip)
  scp -A -r ./source/* ec2-user@"$public_ip":/home/ec2-user
  ssh -A -tt ec2-user@"$public_ip" \
    "docker login ghcr.io -u $GHCR_USERNAME --password-stdin <<< $GHCR_PASSWORD;" \
    "export NEXT_VERSION=$NEXT_VERSION;" \
    "export NEST_VERSION=$NEST_VERSION;" \
    "docker compose up -d --build;" \
    "docker compose restart nginx;"
}

function main() {
    case $1 in
        help) help "$@";;
        ip) get_ec2_public_ip "$@";;
        provision) provision "$@";;
        destroy) destroy "$@";;
        connect) connect "$@";;
        deploy) deploy "$@";;
        *) echo "Unknown command: $1"; exit 1;;
    esac
}

main "$@"
