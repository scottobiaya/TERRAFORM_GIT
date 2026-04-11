#!/bin/bash

# Update system
yum update -y

# Install Docker
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker

# Install Git
yum install -y git

# Add user to docker group
usermod -aG docker ec2-user

# Wait for Docker
sleep 30

# Clone repo (with Dockerfile)
git clone https://github.com/YOUR-USERNAME/YOUR-REPO.git
cd YOUR-REPO

# Build image
docker build -t my-vault .

# Run Vault (NO vault.hcl)
docker run -d \
  -p 8200:8200 \
  --name vault \
  -e VAULT_DEV_ROOT_TOKEN_ID=root \
  -e VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:8200 \
  my-vault server -dev