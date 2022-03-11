Triggering actions is how Spinnaker knows to find artifacts.

We'll establish a webhook trigger from github to our spinnaker in order to
associate a specific repository with the pipeline, and therfore associate
our defined artifacts for use in the pipeline.

In github.com navigate to Settings->Webhooks->Add Webhook, and point the url at:
gate.<ingress_dns_root>/webhooks/git/github or if you only have an IP, then at http://IP/webhooks/git/github

the content needs to be delivered as type application/json

And you should configure a secret (we'll use it in our Pipeline to connect the webhook).
