#!/bin/bash
set -euxo pipefail  # Enable strict error handling

# Prevent interactive prompts
export DEBIAN_FRONTEND=noninteractive

# Update system packages
sudo apt update -y
sudo apt upgrade -y

# Install required dependencies without prompts
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release conntrack socat

# Install Docker
sudo apt remove -y docker docker-engine docker.io containerd runc || true
sudo apt install -y docker.io
sudo systemctl enable --now docker

# Add user to the docker group
sudo usermod -aG docker ubuntu

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

# Install cri-dockerd (needed for Kubernetes 1.24+ with Docker runtime)
sudo apt install -y git golang-go
git clone https://github.com/Mirantis/cri-dockerd.git /home/ubuntu/cri-dockerd
cd /home/ubuntu/cri-dockerd
mkdir -p bin
go build -o bin/cri-dockerd
sudo install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
sudo cp -r packaging/systemd/* /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable --now cri-docker.service cri-docker.socket

# Start Minikube with Docker driver
sudo -u ubuntu minikube start --driver=docker --memory=1800mb --force

