# Minikube terraform configuration

## Setup steps
1. Run the Deploy Minikube pipeline
2. ssh into the EC2 instance with the SSH key that gets created by the pipeline  
    - if needed, run: ```sudo -i -u ubuntu bash
minikube start --driver=docker; minikube start --driver=docker```
3. copy over your deployment scripts into the instance and deploy

## Architecture
The terraform configuration will create the following resources:
- EC2 instance to host the minikube service
- SSH key to connect to the instance
- security group to allow the proper networking for the instance (only allowing connection from my IP)