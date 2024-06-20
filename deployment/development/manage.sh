#!/bin/bash

readonly GREEN='\033[0;32m'
readonly NC='\033[0m'

function help() {
    echo -e "Usage: $0 <command>"
    echo -e
    echo -e "Commands:"
    echo -e "  ${GREEN}help${NC}       Show this help message"
    echo -e "  ${GREEN}setup${NC}      Setup the development environment"
    echo -e "  ${GREEN}env${NC}        Create the .env file"
    echo -e "  ${GREEN}up${NC}         Start the development environment"
    echo -e "  ${GREEN}down${NC}       Stop the development environment"
    echo -e "  ${GREEN}logs${NC}       Show the logs of the development environment"
    echo -e "  ${GREEN}certs${NC}      Generate the SSL certificates"
    echo -e "  ${GREEN}deps${NC}       Install the dependencies"
    echo -e "  ${GREEN}migrate${NC}    Run the migrations"
    echo -e "  ${GREEN}seed${NC}       Seed the database"
}

function setup() {
    env
    certs
    up
    deps
    migrate
    seed
}

function env() {
    cp -n .env.example .env | true
}

function up() {
    docker compose up -d
}

function down() {
    docker compose down
}

function logs() {
    docker compose logs -f
}

function certs() {
    mkcert -cert-file nginx/ssl/server.crt -key-file nginx/ssl/server.key example.localhost \*.example.localhost
}

function deps() {
    docker compose exec nestjs yarn install
    docker compose exec nextjs yarn install
}

function migrate() {
    docker compose exec nestjs yarn prisma:migrate
}

function seed() {
    docker compose exec nestjs yarn prisma:seed
}

function main() {
    case $1 in
        help) help "$@";;
        setup) setup "$@";;
        env) env "$@";;
        up) up "$@";;
        down) down "$@";;
        logs) logs "$@";;
        certs) certs "$@";;
        deps) deps "$@";;
        migrate) migrate "$@";;
        seed) seed "$@";;
        *) echo "Unknown command: $1"; exit 1;;
    esac
}

main "$@"
