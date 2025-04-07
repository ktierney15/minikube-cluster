# Helm Example Deployment

## How to deploy
1. to get started, install helm: ```curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash```
2. Copy over the example-deployments/helm directory to the instance
    - optional: change config to however you want
3. navigate into the helm directory and run: ```helm create [your chart name]```. This will create your project
4. navigate to your chart directory and run: ```helm install [chart name] .```
5. validate your deployment with: ```kubectl get all```
    - optional: to delete your deployment run: ```helm uninstall [chart name]```

