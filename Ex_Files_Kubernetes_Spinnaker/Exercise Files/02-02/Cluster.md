Navigate to your cloned github repository (the clone of hostname)

or Clone it to your local machine (assumes you have a git client locally)

git clone https://github.com/robertstarmer/hostname

In either case naviage to the manifests directory, open the deploy.yaml manifest, and select the entire text to paste into the Spinnaker UI.

In the spinnaker UI, select the Infrastructure tab in your application (this is the default), and then select Clusters and "create cluster"

Paste the contents from the deploy.yaml manifest into the create window, and create the cluster.

You should now have a cluster called hostname, with 3 green squares implying 3 containers having been deployed.

