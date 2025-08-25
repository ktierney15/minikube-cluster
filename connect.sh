#!/bin/bash

# --- Prompt for user input ---
read -p "Enter EC2 username (default: ubuntu): " EC2_USER
EC2_USER=${EC2_USER:-ubuntu}

read -p "Enter EC2 public IP: " EC2_HOST
if [[ -z "$EC2_HOST" ]]; then
  echo "EC2 IP is required!"
  exit 1
fi

read -p "Enter path to your PEM key (default: minikube-key.pem): " EC2_KEY_PATH
EC2_KEY_PATH=${EC2_KEY_PATH:-minikube-key.pem}

read -p "Enter local path to store kubeconfig (default: ~/.kube/config-ec2-minikube): " LOCAL_KUBECONFIG_EC2
LOCAL_KUBECONFIG_EC2=${LOCAL_KUBECONFIG_EC2:-$HOME/.kube/config-ec2-minikube}

read -p "Enter SSH tunnel port (default: 8443): " SSH_TUNNEL_PORT
SSH_TUNNEL_PORT=${SSH_TUNNEL_PORT:-8443}

REMOTE_MINIKUBE_PROFILE="/home/$EC2_USER/.minikube/profiles/minikube"
REMOTE_MINIKUBE_CERTS="/home/$EC2_USER/.minikube/certs"

# --- STEP 1: Copy Minikube certs from EC2 ---
mkdir -p "$HOME/.kube/minikube-certs"

echo "Copying CA cert..."
scp -i "$EC2_KEY_PATH" "$EC2_USER@$EC2_HOST:$REMOTE_MINIKUBE_CERTS/ca.pem" "$HOME/.kube/minikube-certs/ca.crt"

echo "Copying client certs..."
scp -i "$EC2_KEY_PATH" "$EC2_USER@$EC2_HOST:$REMOTE_MINIKUBE_PROFILE/client.crt" "$HOME/.kube/minikube-certs/"
scp -i "$EC2_KEY_PATH" "$EC2_USER@$EC2_HOST:$REMOTE_MINIKUBE_PROFILE/client.key" "$HOME/.kube/minikube-certs/"

# --- STEP 2: Create kubeconfig for EC2 Minikube ---
cat > "$LOCAL_KUBECONFIG_EC2" <<EOF
apiVersion: v1
clusters:
- cluster:
    certificate-authority: $HOME/.kube/minikube-certs/ca.crt
    server: https://127.0.0.1:$SSH_TUNNEL_PORT
  name: minikube-ec2
contexts:
- context:
    cluster: minikube-ec2
    user: minikube-ec2
  name: minikube-ec2
current-context: minikube-ec2
users:
- name: minikube-ec2
  user:
    client-certificate: $HOME/.kube/minikube-certs/client.crt
    client-key: $HOME/.kube/minikube-certs/client.key
EOF

# --- STEP 3: Merge with existing kubeconfig ---
KUBECONFIG="$HOME/.kube/config:$LOCAL_KUBECONFIG_EC2" kubectl config view --merge --flatten > "$HOME/.kube/config-merged"
mv "$HOME/.kube/config-merged" "$HOME/.kube/config"

echo "✅ EC2 Minikube kubeconfig merged! Use context 'minikube-ec2':"
kubectl config get-contexts
