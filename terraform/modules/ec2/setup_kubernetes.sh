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

# Install K9S terminal UI
sudo curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep browser_download_url | grep Linux_x86_64.tar.gz | cut -d '"' -f 4 | wget -qi -
sudo tar -zxvf k9s_Linux_x86_64.tar.gz
sudo cp k9s /usr/local/bin/
sudo k9s -v

# Install K8S by using the K3S
sudo curl -sfL https://get.k3s.io | sh -
sudo bash -c 'echo "alias kubectl=\"kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml\"" > /etc/profile.d/kubectl_alias.sh'
sudo chmod +x /etc/profile.d/kubectl_alias.sh
source /etc/profile.d/kubectl_alias.sh
sudo kubectl get nodes
sudo kubectl version
