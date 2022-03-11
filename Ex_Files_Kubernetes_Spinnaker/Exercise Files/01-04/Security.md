Find our halyard pod:

kubectl get pods -n spinnaker -l 

kubectl exec --namespace spinnaker -it cd-spinnaker-halyard-0 bash
echo "host: 0.0.0.0" | tee \
    ~/.hal/default/service-settings/gate.yml \
    ~/.hal/default/service-settings/deck.yml
hal deploy apply

hal config security ui edit \
    --override-base-url http://spinnaker.<INGRESS_DOMAIN>

hal config security api edit \
    --override-base-url http://gate.<INGRESS_DOMAIN>
hal deploy apply

hal deploy connect --no-validate
https://www.spinnaker.io/setup/artifacts/github/

