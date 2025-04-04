#!/bin/bash

# Log user-data execution
exec > /var/log/user-data.log 2>&1
set -euxo pipefail

# Update system packages
apt update -y && apt upgrade -y

# Install dependencies
apt install -y docker.io jq conntrack

# Start and enable Docker
systemctl enable --now docker

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# Install Minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
mv minikube /usr/local/bin/

# Allow non-root users to run Minikube (optional)
usermod -aG docker ubuntu

# Start Minikube (as ubuntu user)
runuser -l ubuntu -c "minikube start --driver=docker"

# Configure kubectl for ubuntu user
runuser -l ubuntu -c "mkdir -p \$HOME/.kube && minikube kubectl -- get pods"

# Create a systemd service for Minikube to make it persistent
cat <<EOF > /etc/systemd/system/minikube.service
[Unit]
Description=Minikube Cluster
After=docker.service
Requires=docker.service

[Service]
User=ubuntu
ExecStart=/usr/local/bin/minikube start --driver=docker
ExecStop=/usr/local/bin/minikube stop
Restart=always
Environment="HOME=/home/ubuntu"
WorkingDirectory=/home/ubuntu

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the Minikube service
systemctl enable --now minikube

# Print status
echo "Minikube has been installed and started successfully!"