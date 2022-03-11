Configure an AKS environment with 3 nodes (the standard node size should be adequate)

https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

az login

az group create --name aksresgrp --location eastus
az aks create \
    --resource-group aksresgrp \
    --name akscluster \
    --node-count 3 \
    --generate-ssh-keys

Once the AKS environment is up, establish your kubernetes credentials with the Azure CLI (az):

az aks get-credentials --resource-group aksresgrp --name akscluster -f ../config --admin
export KUBECONFIG=$PWD/../config

If we need the kubectl command, we can get it installed with the az cli:

az aks install-cli

And then we can install Helm:



