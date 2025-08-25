# minikube-cluster
Development Minikube cluster to test out K8s deployment configurations

## Components
- [IAC](IAC/README.md): Terraform configuration for minikube ec2 instance
- example-deployments: example deployments to the cluster 
    - [kubectl](example-deployments/kubectl/README.md)
    - [helm](example-deployments/helm/README.md)
    - [kustomize](example-deployments/kustomize/README.md)
- .github/workflows: CI/CD pipelines
- my-deployments: my personal deployments to the cluster