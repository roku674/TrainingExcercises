In the same manifests directory (from hostname git repository), there is a service.yaml document, select the contents of this file.

In the spinnaker UI, select the Infrastructure tab in your application (this is the default), and then select LoadBalancers and "create loadbalancer" 

Paste the contents from the service.yaml manifest into the create window, and create the loadbalancer.

You should now have a loadbalancer created, called "service hostname", and it should be pointing at a replicaset, which actually maps to the replicaset underlying the hostname cluster from the previous chapter.

