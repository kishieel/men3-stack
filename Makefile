SHELL := /bin/bash

.PHONY: help
help: # Show help for each of the Makefile recipes.
	@printf "%-10s  %-80s\n" "Usage:" "make [target]"
	@grep -E '^[a-zA-Z0-9 -]+:.*#' Makefile | while read -r l; do printf "\033[1;32m%-10s\033[00m %-80s\n" "$$(echo $$l | cut -f 1 -d':')" "$$(echo $$l | cut -f 2- -d'#')"; done

.PHONY: up
up: # Start the docker containers for local development.
	docker compose up -d

.PHONY: down
down: # Stop the docker containers for local development.
	docker compose down

.PHONY: logs
logs: # Show the logs for the docker containers.
	docker compose logs -f
