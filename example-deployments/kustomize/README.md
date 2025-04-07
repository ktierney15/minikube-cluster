# Kustomize Example Deployment

## How to deploy
1. install kustomize: ```sudo snap install kustomize```
2. Copy over the example-deployments/kustomize directory to the instance
    - optional: change config to however you want
3. navigate to the kustomize directory and run: ```kustomize build . | kubectl apply -f -```. This will deploy your configuration
4.  validate your deployment with: ```kubectl get all```
    - optional: to delete your deployment run: ```kubectl delete -k .```