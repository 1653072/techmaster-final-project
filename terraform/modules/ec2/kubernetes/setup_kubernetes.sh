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
sudo wget https://github.com/derailed/k9s/releases/download/v0.32.7/k9s_linux_amd64.deb
sudo apt install ./k9s_linux_amd64.deb
sudo rm k9s_linux_amd64.deb
sudo k9s info

# Install K8S by using the K3S & Create 2 main namespaces (i.e "dev" and "prd")
sudo curl -sfL https://get.k3s.io | sh -
sudo bash -c 'echo "alias kubectl=\"kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml\"" > /etc/profile.d/kubectl_alias.sh'
sudo chmod +x /etc/profile.d/kubectl_alias.sh
source /etc/profile.d/kubectl_alias.sh
sudo chmod 644 /etc/rancher/k3s/k3s.yaml
sudo kubectl version
sudo kubectl create namespace dev
sudo kubectl create namespace prd
sudo kubectl get nodes --all-namespaces

# [NodeExporter] Step 1: Installation
sudo wget https://github.com/prometheus/node_exporter/releases/latest/download/node_exporter-1.8.2.linux-amd64.tar.gz
sudo tar xvfz node_exporter-1.8.2.linux-amd64.tar.gz
cd node_exporter-1.8.2.linux-amd64
sudo mv node_exporter /usr/local/bin/

# [NodeExporter] Step 2: Create the systemd service file for Node Exporter
sudo bash -c "cat <<EOL > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=nobody
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOL"

# [NodeExporter] Step 3: Start Node Exporter through the systemd service
sudo systemctl daemon-reload # Reload the systemd daemon
sudo systemctl start node_exporter # Start the service
sudo systemctl enable node_exporter # Enable the service to start on boot
sudo systemctl status node_exporter # Verify that the service is running
