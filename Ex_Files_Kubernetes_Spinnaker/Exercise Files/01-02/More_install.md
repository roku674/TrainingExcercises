We'll need helm connected to our Kubernetes cluster

kubectl apply -f helm-rbac.yaml
helm init --service-account=tiller

Then we'll want to install prometheus in order to collect metrics for our Canary efforts
helm install --name prom --set server.persistentVolume.storageClass=default stable/prometheus

