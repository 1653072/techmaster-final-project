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
  -itd --name jenkins-server jenkins/jenkins:latest
sudo chmod 666 /var/run/docker.sock
echo 'Jenkins installed'
sudo docker ps | grep jenkins-server

# Install ArgoCD by Docker
docker run -p 9080:8080 \
  -e ARGOCD_SERVER_INSECURE=true \
  --restart=always \
  -itd --name argocd-server argoproj/argocd:latest
echo 'ArgoCD installed'
sudo docker ps | grep argocd

# Install cAdvisor of Google to collect resource usage and performance characteristics of all containers
# in this instance, even including the Jenkins and ArgoCD.
# We'll grants this Docker "cAdvisor" container root capabilities to all devices on the host system.
docker run -itd \
  --name=cadvisor \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --publish=8081:8080 \
  --detach=true \
  --privileged \
  google/cadvisor:latest
echo 'CAdvisor installed'
sudo docker ps | grep cadvisor

# [Part 1] Install Node Exporter
sudo wget https://github.com/prometheus/node_exporter/releases/latest/download/node_exporter-1.8.2.linux-amd64.tar.gz
sudo tar xvfz node_exporter-1.8.2.linux-amd64.tar.gz
cd node_exporter-1.8.2.linux-amd64
sudo mv node_exporter /usr/local/bin/

# [Part 2] Create the systemd service file for Node Exporter
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

# [Part 3] Start Node Exporter
sudo systemctl daemon-reload # Reload the systemd daemon
sudo systemctl start node_exporter # Start the Node Exporter service
sudo systemctl enable node_exporter # Enable the Node Exporter service to start on boot
sudo systemctl status node_exporter # Verify that the Node Exporter is running
