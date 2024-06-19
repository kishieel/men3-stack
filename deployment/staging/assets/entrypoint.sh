#!/bin/bash

# Install Docker with Docker Compose
yum update -y
amazon-linux-extras install docker -y

# Install Docker Compose
mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.27.1/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# Add the ec2-user to the docker group so you can execute Docker commands without using sudo.
groupadd docker
usermod -a -G docker ec2-user

# Start Docker
systemctl enable docker
systemctl start docker
