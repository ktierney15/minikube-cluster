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

# Allow 'ubuntu' user to run Docker
usermod -aG docker ubuntu

# Create necessary home directories
mkdir -p /home/ubuntu
chown -R ubuntu:ubuntu /home/ubuntu

# Start Minikube as the 'ubuntu' user
sudo -u ubuntu -i /usr/local/bin/minikube start --driver=docker --wait=all

# Print completion message
echo "Minikube has been installed and started!"



# #!/bin/bash

# # Log user-data execution
# exec > /var/log/user-data.log 2>&1
# set -euxo pipefail

# # Update system packages
# apt update -y && apt upgrade -y

# # Install dependencies
# apt install -y docker.io jq conntrack

# # Start and enable Docker
# systemctl enable --now docker

# # Install kubectl
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# chmod +x kubectl
# mv kubectl /usr/local/bin/

# # Install Minikube
# curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
# chmod +x minikube
# mv minikube /usr/local/bin/

# # Allow non-root users to run Minikube (optional)
# usermod -aG docker ubuntu

# # Create a systemd service for Minikube with a delay before starting
# cat <<EOF > /etc/systemd/system/minikube-start.service
# [Unit]
# Description=Start Minikube on first login
# After=network.target docker.service
# Requires=docker.service

# [Service]
# User=ubuntu
# Type=simple
# ExecStartPre=/bin/sleep 10  # Delay to ensure Docker is fully initialized
# ExecStart=/usr/local/bin/minikube start --driver=docker
# Restart=always
# Environment="HOME=/home/ubuntu"
# WorkingDirectory=/home/ubuntu

# [Install]
# WantedBy=multi-user.target
# EOF

# # Reload systemd to apply the changes
# systemctl daemon-reload

# # Enable the service so it starts on boot
# systemctl enable minikube-start

# # Print status
# echo "Minikube has been installed, and the startup service has been configured!"


# #!/bin/bash

# # Log user-data execution
# exec > /var/log/user-data.log 2>&1
# set -euxo pipefail

# # Update system packages
# apt update -y && apt upgrade -y

# # Install dependencies
# apt install -y docker.io jq conntrack

# # Start and enable Docker
# systemctl enable --now docker

# # Install kubectl
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# chmod +x kubectl
# mv kubectl /usr/local/bin/

# # Install Minikube
# curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
# chmod +x minikube
# mv minikube /usr/local/bin/

# # Allow non-root users to run Minikube (optional)
# usermod -aG docker ubuntu

# # Small sleep to ensure Docker is fully ready
# sleep 10

# # Start Minikube as ubuntu user
# runuser -l ubuntu -c "minikube start --driver=docker"

# # Configure kubectl for ubuntu user
# runuser -l ubuntu -c "mkdir -p \$HOME/.kube && minikube kubectl -- get pods"

# # Print status
# echo "Minikube has been installed and started successfully!"