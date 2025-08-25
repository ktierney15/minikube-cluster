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


# connecting locally
1. download the pem key from the workflow run and give it permissions
```bash
chmod 400 minikube-key.pem
```

2. Set up a tunnel to the ec2 instance via the connection script
```bash
sh connect.sh
```

3. Test connection
```bash

```