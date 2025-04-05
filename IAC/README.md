# Minikube terraform configuration

## Setup steps
1. Run the Deploy Minikube pipeline
2. ssh into the EC2 instance with the SSH key that gets created by the pipeline
3. Export the kubeconfig with the following command: kubectl config view --flatten --minify --raw
4. Save that value as the KUBECONFIG secret in the repository, and you are ready to deploy to the cluster

## Architecture
The terraform configuration will create the following resources:
- EC2 instance to host the minikube service
    - The EC2 will use the user data script to install the needed resources
- SSH key to connect to the instance
- security group to allow the proper networking for the instance