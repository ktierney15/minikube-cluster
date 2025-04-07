#!/bin/bash

# Log user-data execution
exec > /var/log/user-data.log 2>&1
set -euxo pipefail

apt update -y && apt upgrade -y

# Setup dependencies
apt install -y docker.io jq conntrack

systemctl enable --now docker

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
mv minikube /usr/local/bin/

usermod -aG docker ubuntu

# Create a systemd service
cat <<EOF > /etc/systemd/system/minikube-start.service
[Unit]
Description=Start Minikube on first login
After=network.target docker.service
Requires=docker.service

[Service]
User=ubuntu
Type=simple
ExecStartPre=/bin/sleep 10  # Delay to ensure Docker is fully initialized
ExecStart=/usr/local/bin/minikube start --driver=docker
Restart=always
Environment="HOME=/home/ubuntu"
WorkingDirectory=/home/ubuntu

[Install]
WantedBy=multi-user.target
EOF

# Enable service
systemctl daemon-reload
systemctl enable minikube-start
sudo -u ubuntu -i /usr/local/bin/minikube start --driver=docker --wait=all # possibly remove
echo "User Data Script complete"
