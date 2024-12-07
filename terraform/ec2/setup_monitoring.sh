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

# Install Prometheus by Docker
cat <<EOL > "prometheus.yml"
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['prometheus:9090']
EOL

docker run -p 9090:9090 \
  -v ./prometheus.yml:/etc/prometheus/prometheus.yml \
  --restart=always \
  -itd --name prometheus-server prom/prometheus:latest
echo 'Prometheus installed'
docker ps | grep prometheus

# Install Grafana by Docker
docker run -p 3000:3000 \
  --restart=always \
  -itd --name grafana-server grafana/grafana:latest
echo 'Grafana installed'
docker ps | grep grafana
