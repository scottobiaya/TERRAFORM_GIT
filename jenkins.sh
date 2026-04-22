#!/bin/bash
set -euxo pipefail
exec > /var/log/user-data.log 2>&1

# Install Docker
yum install -y docker
systemctl enable docker
systemctl start docker

# Run Jenkins container
docker run -d \
  -p 8080:8080 \
  --name jenkins \
  -v jenkins_home:/var/jenkins_home \
  -e JENKINS_OPTS="--prefix=/jenkins" \
  jenkins/jenkins:lts