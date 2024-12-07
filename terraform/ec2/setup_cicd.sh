#!/bin/bash

# Update the package list and upgrade the installed packages
sudo apt-get update -y

# Add Swap Memory of 3GB
sudo swapon --show
free -h
df -h
sudo fallocate -l 3G /swapfile
ls -lh /swapfile
sudo chmod 600 /swapfile
ls -lh /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon --show
free -h
cat /proc/sys/vm/swappiness
sudo sysctl vm.swappiness=10
cat /proc/sys/vm/vfs_cache_pressure
sudo sysctl vm.vfs_cache_pressure=50

# Install essential packages
sudo apt-get install -y curl net-tools wget unzip tree make

# Install Docker
sudo apt-get install -y docker.io

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Start the Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Output Docker and Docker Compose versions
docker --version
docker-compose --version

# Install Jenkins by Docker
docker run -p 8080:8080 -p 50000:50000 \
  -v jenkins_server:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --restart=always \
  -itd --name jenkins-server jenkins:latest
chmod 666 /var/run/docker.sock
echo 'Jenkins installed'
docker ps | grep jenkins-server

# Install ArgoCD by Docker
docker run -p 9080:8080 \
  -e ARGOCD_SERVER_INSECURE=true \
  --restart=always \
  -itd --name argocd-server argoproj/argocd:latest
echo 'ArgoCD installed'
docker ps | grep argocd
