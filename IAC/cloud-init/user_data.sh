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

# Small sleep to ensure Docker is fully ready
sleep 10

# Start Minikube as ubuntu user
runuser -l ubuntu -c "minikube start --driver=docker"

# Configure kubectl for ubuntu user
runuser -l ubuntu -c "mkdir -p \$HOME/.kube && minikube kubectl -- get pods"

# Print status
echo "Minikube has been installed and started successfully!"
