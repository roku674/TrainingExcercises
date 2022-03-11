There is a flexible parameterization language that we can use to modify our manifests, even in a currently static environment, for example, we likely will want to modify the number of deployed replicas, and likely the target namespace in our kubernetes environment, so we can parameterize those resources even if we pull them from a static input like our initial cluster and load balancer definitions.

We have a parameterized version of our deploy and service manifests (deploy-spinnaker.yaml and service-spinnaker.yaml respectively).

An example parameterization, including a conversion to integer:

'${ #toInt( parameters.replicas ?: 3) }'

or a simple value
'${ parameters.namespace }'
