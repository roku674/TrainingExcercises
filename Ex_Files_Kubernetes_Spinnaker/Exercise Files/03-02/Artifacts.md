In order to enable an artifact account (and you can enable multiple) we need to use halyard to configure Spinnaker.

We will also need a personal access token from Github in order to allow Spinnaker to read from the Github API against our repositories.
We need to acquire the token from github.com under Settings->Developer Settings->Personal Access Tokens. Select only repo_status and public_repo boxes (unless you need access to private repositories).

Make a copy of the token and store it somewhere safe, or just re-create the token if you need to re-configure your environment (a safer option).

kubectl exec --namespace spinnaker -it cd-spinnaker-halyard-0 bash

hal config features edit --artifacts true
hal config artifact github enable

hal config artifact github account add <account_name> --token

hal deploy apply

