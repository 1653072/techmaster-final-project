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
sudo sh -c 'echo "/swapfile swap swap defaults 0 0" >> /etc/fstab'
sudo sh -c 'echo "vm.swappiness=10" >> /etc/sysctl.conf'
sudo sh -c 'echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf'
sudo sysctl -p

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

# [ArgoCD] Step 1: Install ArgoCD CLI
export ARGOCD_VERSION=$(curl -L -s https://raw.githubusercontent.com/argoproj/argo-cd/stable/VERSION)
sudo curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v$ARGOCD_VERSION/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
sudo rm argocd-linux-amd64

# [ArgoCD] Step 2:
# - Install K8S by using the K3S.
# - Update mod for the "k3s.yaml" file to allow "user=nobody" in systemd to read it.
sudo curl -sfL https://get.k3s.io | sh -
sudo bash -c 'echo "alias kubectl=\"kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml\"" > /etc/profile.d/kubectl_alias.sh'
sudo chmod +x /etc/profile.d/kubectl_alias.sh
source /etc/profile.d/kubectl_alias.sh
sudo chmod 644 /etc/rancher/k3s/k3s.yaml
sudo kubectl get nodes
sudo kubectl version

# [ArgoCD] Step 3:
# - Install and Run ArgoCD K8S.
# - Update the "argocd-server" service type to LoadBalancer to expose the ArgoCD APIs for external access
# on the 9080 port which forwards to 443.
# - Wait for all ArgoCD pods to be ready before going to next steps with the max timeout 180 seconds.
sudo kubectl create namespace argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sudo kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
sudo kubectl get pods -n argocd -o wide
sudo kubectl wait -n argocd --for=condition=Ready pod --all --timeout=180s

# [ArgoCD] Step 4: Create the systemd service file for ArgoCD K8S Port-Forward
# - Format: Host_Port -> K8S_Service_Port
# - argocd-server (UI website & APIs): 9080 -> 443
# - argocd-metrics (Overall metrics): 9082 -> 8082
# - argocd-server-metrics (Server metrics) 9083 -> 8083
# - argocd-repo-server (Repo server metrics): 9084 -> 8084
sudo tee /usr/local/bin/argocd_port_forward_script.sh > /dev/null <<EOL
#!/bin/bash

# Terminate any existing port-forward processes.
pkill -f 'kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml port-forward'

# Start new port-forward processes, then wait all processes to be available.
/usr/local/bin/kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml port-forward svc/argocd-server -n argocd 9080:443 --address 0.0.0.0 &
/usr/local/bin/kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml port-forward svc/argocd-metrics -n argocd 9082:8082 --address 0.0.0.0 &
/usr/local/bin/kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml port-forward svc/argocd-server-metrics -n argocd 9083:8083 --address 0.0.0.0 &
/usr/local/bin/kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml port-forward svc/argocd-repo-server -n argocd 9084:8084 --address 0.0.0.0 &

wait
EOL
sudo chmod +x /usr/local/bin/argocd_port_forward_script.sh

sudo bash -c "cat <<EOL > /etc/systemd/system/argocd_port_forward.service
[Unit]
Description=ArgoCD Port Forward
Wants=network-online.target
After=network-online.target

[Service]
User=nobody
ExecStart=/usr/local/bin/argocd_port_forward_script.sh
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=default.target
EOL"

# [ArgoCD] Step 5: Start ArgoCD K8S Port-Forward through the systemd service
sudo systemctl daemon-reload # Reload the systemd daemon
sudo systemctl start argocd_port_forward # Start the service
sudo systemctl enable argocd_port_forward # Enable the service to start on boot
sudo systemctl status argocd_port_forward # Verify that the service is running

# [ArgoCD] Step 6: Automatically change the default ArgoCD Admin password to the initial given password through the "argocd-server" service
export DEFAULT_ARGOCD_ADMIN_PASSWORD=$(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
sudo argocd login localhost:9080 --username admin --password $DEFAULT_ARGOCD_ADMIN_PASSWORD --insecure && sudo argocd account update-password \
  --account admin \
  --current-password $DEFAULT_ARGOCD_ADMIN_PASSWORD \
  --new-password ${INITIAL_ARGOCD_ADMIN_PASSWORD} \
  --server localhost:9080 \
  --insecure

# Install Jenkins by Docker, finally install the Docker inside the Jenkins container.
docker run -p 8080:8080 -p 50000:50000 \
  -v jenkins_server:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --restart=always \
  -itd --name jenkins-server jenkins/jenkins:latest
sudo chmod 666 /var/run/docker.sock
echo 'Jenkins installed'
sudo docker ps | grep jenkins-server
sudo docker exec -it -u root jenkins-server /bin/bash -c "apt-get update && apt-get install -y docker.io && docker --version"
echo 'Installed Docker inside Jenkins container'

# Install cAdvisor of Google to collect resource usage and performance characteristics of all containers
# in this instance, even including the Jenkins server.
# We'll grants this Docker "cAdvisor" container root capabilities to all devices on the host system.
docker run -itd \
  --name=cadvisor-server \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8081:8080 \
  --detach=true \
  --privileged \
  --device=/dev/kmsg \
  --restart=always \
  gcr.io/cadvisor/cadvisor:latest
echo 'CAdvisor installed'
sudo docker ps | grep cadvisor

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
