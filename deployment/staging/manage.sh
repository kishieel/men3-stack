#!/bin/bash

readonly GREEN='\033[0;32m'
readonly NC='\033[0m'

function help() {
    echo -e "Usage: $0 <command>"
    echo -e
    echo -e "Commands:"
    echo -e "  ${GREEN}help${NC}       Show this help message"
    echo -e "  ${GREEN}setup${NC}      Setup the staging environment"
    echo -e "  ${GREEN}env${NC}        Create the .env file"
    echo -e "  ${GREEN}provision${NC}  Provision the staging environment"
    echo -e "  ${GREEN}destroy${NC}    Destroy the staging environment"
    echo -e "  ${GREEN}connect${NC}    Connect to the virtual machine"
    echo -e "  ${GREEN}certbot${NC}    Run Certbot on the virtual machine to obtain an SSL certificate"
    echo -e "  ${GREEN}deploy${NC}     Deploy the application to the staging environment"
}

function setup() {
  env
  provision
  certbot
  deploy
}

function env() {
  cp -n .env.example .env
  source .env

  if [[ -z "$GHCR_USERNAME" ]]; then
    echo -e -n "${GREEN}Enter your GitHub Container Registry username:${NC} "
    read -r ghcr_username
    sed -i "s/GHCR_USERNAME=.*/GHCR_USERNAME=$ghcr_username/" .env
  fi

  if [[ -z "$GHCR_PASSWORD" ]]; then
    echo -e -n "${GREEN}Enter your GitHub Container Registry password:${NC} "
    read -r -s ghcr_password
    sed -i "s/GHCR_PASSWORD=.*/GHCR_PASSWORD=$ghcr_password/" .env
  fi

  if [[ -z "$DOMAIN_NAME" ]]; then
    echo -e -n "${GREEN}Enter the domain name for the Nginx server:${NC} "
    read -r nginx_domain
    sed -i "s/DOMAIN_NAME=.*/DOMAIN_NAME=$nginx_domain/" .env
  fi
}

function terraform_env() {
  source .env

  export TF_VAR_aws_region="$AWS_REGION"
  export TF_VAR_aws_availability_zone="$AWS_AVAILABILITY_ZONE"
  export TF_VAR_aws_ami_id="$AWS_AMI_ID"
  export TF_VAR_aws_instance_type="$AWS_INSTANCE_TYPE"
  export TF_VAR_aws_ssh_cidr_blocks="$AWS_SSH_CIDR_BLOCKS"
}

function provision() {
  terraform_env
  terraform -chdir=terraform apply -auto-approve
}

function destroy() {
  terraform_env
  terraform -chdir=terraform destroy -auto-approve
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

function certbot() {
  source .env
  ssh_agent

  local public_ip; public_ip=$(get_ec2_public_ip)

  ssh -A -tt ec2-user@"$public_ip" \
    "export DOMAIN_NAME=$DOMAIN_NAME;" \
    "export AWS_REGION=$AWS_REGION;" \
    "docker run -it --rm -p 80:80 --name certbot -v ./letsencrypt:/etc/letsencrypt certbot/certbot:latest certonly --standalone --email ${CERTBOT_EMAIL} --agree-tos --no-eff-email --force-renewal -d ${DOMAIN_NAME} -d www.${DOMAIN_NAME};"
}

function deploy() {
  source .env
  ssh_agent

  local public_ip; public_ip=$(get_ec2_public_ip)

  scp -A -r ./source/* ec2-user@"$public_ip":/home/ec2-user
  ssh -A -tt ec2-user@"$public_ip" \
    "docker login ghcr.io -u $GHCR_USERNAME --password-stdin <<< $GHCR_PASSWORD;" \
    "export NEXT_VERSION=$NEXT_VERSION;" \
    "export NEST_VERSION=$NEST_VERSION;" \
    "export CERTBOT_EMAIL=$CERTBOT_EMAIL;" \
    "export DOMAIN_NAME=$DOMAIN_NAME;" \
    "export AWS_REGION=$AWS_REGION;" \
    "docker compose up -d --build;" \
    "docker compose exec nestjs yarn prisma:deploy;" \
    "docker compose restart nginx;"
}

function main() {
    case $1 in
        help) help "$@";;
        setup) setup "$@";;
        env) env "$@";;
        provision) provision "$@";;
        destroy) destroy "$@";;
        connect) connect "$@";;
        certbot) certbot "$@";;
        deploy) deploy "$@";;
        *) echo "Unknown command: $1"; exit 1;;
    esac
}

main "$@"
