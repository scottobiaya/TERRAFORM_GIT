#!/bin/bash

# Log everything (VERY IMPORTANT for debugging)
exec > /var/log/user-data.log 2>&1

# Update system
yum update -y

# Install Docker
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker

# Install Git
yum install -y git

# Add ec2-user to docker group
usermod -aG docker ec2-user

# Wait for Docker to fully start
sleep 30

# OPTIONAL: create working directory
mkdir -p /home/ec2-user/app
cd /home/ec2-user/app

# Clone your repo (must contain Dockerfile)
git clone https://github.com/YOUR-USERNAME/YOUR-JENKINS-REPO.git
cd YOUR-JENKINS-REPO

# Build Jenkins image
docker build -t my-jenkins .

# Run Jenkins container
docker run -d \
  -p 8080:8080 \
  --name jenkins \
  my-jenkins

# Print container status
docker ps