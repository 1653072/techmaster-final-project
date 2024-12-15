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

# Install K8S by using the K3S Server & Create 2 main namespaces (i.e "dev" and "prd")
sudo curl -sfL https://get.k3s.io | sh -
sudo bash -c 'echo "alias kubectl=\"kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml\"" > /etc/profile.d/kubectl_alias.sh'
sudo chmod +x /etc/profile.d/kubectl_alias.sh
source /etc/profile.d/kubectl_alias.sh
sudo chmod 644 /etc/rancher/k3s/k3s.yaml
sudo kubectl version
sudo kubectl create namespace dev
sudo kubectl create namespace prd
sudo kubectl get nodes --all-namespaces

# Register the current K3S Server Cluster Context to the ArgoCD K8S Cluster in the CICD instance
# ---
# Documents:
# 1. K3S Server Configs: https://docs.k3s.io/cli/server
# 2. ArgoCD Cluster Configs: https://argo-cd.readthedocs.io/en/latest/user-guide/commands/argocd_cluster_add/
# ---
export CURRENT_PUBLIC_IP=$(sudo curl -s http://checkip.amazonaws.com)
export CURRENT_KUBECONFIG_CONTEXT_NAME="$(sudo kubectl config current-context)"
# ---
export CURRENT_KUBECONFIG_PATH="/etc/rancher/k3s/k3s.yaml"
export CURRENT_KUBECONFIG_PATH_FOR_ARGOCD="/etc/rancher/k3s/k3s_argocd.yaml"
sudo cp $CURRENT_KUBECONFIG_PATH $CURRENT_KUBECONFIG_PATH_FOR_ARGOCD
# We need to change the localhost 127.0.0.1:6443 to the <PublicIP>:6443
sudo sed -i.bak "s|server: https://127.0.0.1:6443|server: https://$CURRENT_PUBLIC_IP:6443|" "$CURRENT_KUBECONFIG_PATH_FOR_ARGOCD"
# ---
export CURRENT_K3S_SERVICE_FILE_PATH="/etc/systemd/system/k3s.service"
# Loop to delete the last line up to 3 times or until reaching the line with "ExecStart"
for i in {1..3}; do
  if tail -n 1 "$CURRENT_K3S_SERVICE_FILE_PATH" | grep -q "ExecStart"; then
    break
  fi
  sudo sed -i '$d' "$CURRENT_K3S_SERVICE_FILE_PATH"
done
# Rewrite the ExecStart of K3S Server by adding the additional PublicIP through the --tls-san argument.
sudo sed -i '/ExecStart=/c\ExecStart=/usr/local/bin/k3s server --tls-san '"$CURRENT_PUBLIC_IP" "$CURRENT_K3S_SERVICE_FILE_PATH"
# Restart the K3S system
sudo systemctl daemon-reload
sudo systemctl restart k3s
# ---
export ARGOCD_SERVER_PORT="9080"
for ip in ${CICD_INSTANCE_PUBLIC_IPS}; do
  # Login to the ArgoCD server with auto approval, then we add the current kubeconfig context to the ArgoCD server with auto approval and the upsert mechanism.
  sudo argocd login "$ip:$ARGOCD_SERVER_PORT" --username admin --password $INITIAL_ARGOCD_ADMIN_PASSWORD --insecure && sudo argocd cluster add $CURRENT_KUBECONFIG_CONTEXT_NAME --yes --insecure --upsert --kubeconfig $CURRENT_KUBECONFIG_PATH_FOR_ARGOCD
done

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
