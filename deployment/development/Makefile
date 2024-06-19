SHELL := /bin/bash

.PHONY: help
help: # Show help for each of the Makefile recipes.
	@printf "%-10s  %-80s\n" "Usage:" "make [target]"
	@grep -E '^[a-zA-Z0-9 -]+:.*#' Makefile | while read -r l; do printf "\033[1;32m%-10s\033[00m %-80s\n" "$$(echo $$l | cut -f 1 -d':')" "$$(echo $$l | cut -f 2- -d'#')"; done

.PHONY: setup
setup: env up certs deps migrate seed # Setup the local development environment.

.PHONY: env
env: # Create the .env file for the local development environment.
	@cp -n .env.example .env | true

.PHONY: up
up: # Start the docker containers for local development.
	@docker compose up -d

.PHONY: down
down: # Stop the docker containers for local development.
	@docker compose down

.PHONY: logs
logs: # Show the logs for the docker containers.
	@docker compose logs -f

.PHONY: certs
certs: # Generate the SSL certificates for the local development environment.
	@mkcert -cert-file nginx/ssl/server.crt -key-file nginx/ssl/server.key example.localhost \*.example.localhost

.PHONY: deps
deps: # Install the dependencies for the projects.
	@docker compose exec nestjs yarn install
	@docker compose exec nextjs yarn install

.PHONY: migrate
migrate: # Run the database migrations.
	@docker compose exec nestjs yarn prisma:migrate

.PHONY: seed
seed: # Seed the database with some initial data.
	@docker compose exec nestjs yarn prisma:seed
