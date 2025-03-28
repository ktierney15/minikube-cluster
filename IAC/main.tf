provider "aws" {
  region = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

terraform {
  backend "s3" {
    bucket = "kt15-terraform-state-files"
    key    = "minikube-cluster/terraform.tfstate"
    region = "us-east-1"
  }
}

## PEM ##
resource "tls_private_key" "minikube" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "minikube_key" {
  key_name   = "minikube-key"
  public_key = tls_private_key.minikube.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.minikube.private_key_pem
  filename = "${path.module}/minikube-key.pem"
}

## Instance ##
resource "aws_security_group" "minikube_sg" {
  name        = "minikube-sg"
  description = "Allow SSH and Kubernetes"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ingress_ip] 
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "minikube" {
  ami           = "ami-028f6d7ddc3079baf" # ubuntu 22.04
  instance_type = "t3.micro"
  key_name      = aws_key_pair.minikube_key.key_name
  security_groups = [aws_security_group.minikube_sg.name]

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y docker
    sudo systemctl enable --now docker
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    sudo minikube start --driver=none
  EOF

  tags = {
    Name = "Minikube-Instance"
  }
}


