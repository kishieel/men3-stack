SHELL := /bin/bash

.PHONY: help
help: # Show help for each of the Makefile recipes.
	@printf "%-10s  %-80s\n" "Usage:" "make [target]"
	@grep -E '^[a-zA-Z0-9 -]+:.*#' Makefile | while read -r l; do printf "\033[1;32m%-10s\033[00m %-80s\n" "$$(echo $$l | cut -f 1 -d':')" "$$(echo $$l | cut -f 2- -d'#')"; done

.PHONY: provision
provision: # Provision the staging environment.
	@terraform apply -auto-approve -var-file=staging.tfvars

.PHONY: destroy
destroy: # Destroy the staging environment.
	@terraform destroy -auto-approve -var-file=staging.tfvars

.PHONY: connect
connect: # Connect to the virtual machine.
	@eval `ssh-agent -s` && \
	ssh-add <(terraform output -json | jq -r '.private_key.value') && \
	ssh -A ec2-user@"$$(terraform output -json | jq -r '.public_ip.value')"

.PHONY: deploy
deploy: # Deploy the application to the staging environment.
	@eval `ssh-agent -s` && \
	ssh-add <(terraform output -json | jq -r '.private_key.value') && \
	scp -r ./assets/docker-compose.yaml ec2-user@"$$(terraform output -json | jq -r '.public_ip.value')":/home/ec2-user/docker-compose.yaml && \
	ssh -A ec2-user@"$$(terraform output -json | jq -r '.public_ip.value')" "docker login ghcr.io -u $$(terraform output -json | jq -r '.ghcr_username.value') -p $$(terraform output -json | jq -r '.ghcr_password.value')" && \
	ssh -A ec2-user@"$$(terraform output -json | jq -r '.public_ip.value')" "docker compose up -d"

# Hmm.. maybe it would be better to use other tools for deployment, like Ansible or Packer.
# These commands in the Makefile are not very readable and maintainable.
