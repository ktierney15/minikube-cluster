# Kubectl Example Deployment

## How to deploy
1. Copy over the example-deployments/kubectl directory to the instance
    - optional: change config to however you want
2. navigate into the kubectl directory and run: ```kubectl apply -f deployment.yml (or whatever your deploying)```. This will deploy your configuration
3. validate your deployment with: ```kubectl get all```
    - optional: to delete your deployment run: ```kubectl delete -f deployment.yml (or whatever you are tearing down)```