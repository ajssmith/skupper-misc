# Skupper debug and monitoring

Miscellaneous operations related to Skupper

* [Cluster cli](#cluster-command-line-tips)
* [Skupper status](#skupper-status)
* [View Logs](#view-deployment-logs)
* [Exec qdtools](#exec-qdtools)
* [Debug dump](#dump-skupper-details)
* [Service Controller get](#skupper-service-controller-get)

## Cluster command line tips

Setting a context and namespace (namespace previously created)

    kubectl config set-context --current --namespace=<namespace>

View current namespace

    kubectl config view --minify | grep namespace

Use an Alias for kubectl

    alias kc=kubectl
    kc version

Resource short names (note shortnames)

    kubectl api-resources

Finding object information

    kubectl describe deploy skupper-router
    kubectl get cm skupper-internal -o yaml

Resource exploration

    kubectl explain deployment.spec

Common Pod error statuses

    `ImagePullBackoff`, `ErrImagePull` - Image could not be pulled from registry
    `CrashLoopBackOff` - Command run in container crashes
    `CreateContainerConfigError` - Referenced ConfigMap or Secret not found

## Skupper status

From the namespace Skupper was deployed, use the Skupper cli to review status

Review component versions (client, skupper-router, skupper-service-controller)

    skupper version

Review site status with connection and service summary

    skupper status

Review site link status

    skupper link status
    skupper link status conn1

## View deployment logs

From the namespace Skupper was deployed, view the qdrouterd logs

   ```bash
   kubectl logs -f deploy/skupper-router
   ```

View the service controller logs

   ```bash
   kubectl logs -f deploy/skupper-service-controller
   ```

## Skupper ConfigMaps

`skupper-internal` holds qdrouterd configuration

    kubectl describe cm skupper-internal

`skupper-sasl-config` holds qdrouterd sasl config file

    kubectl describe cm skupper-sasl-config

`skupper-services` contains known skupper network services

    kubectl describe cm skupper-services

`skupper-site` holds skupper site configuration

    kubectl describe cm skupper-site

## Exec qdtools

From the namespace Skupper was deployed, exec into the deployment

   ```bash
   kubectl exec deploy/skupper-router -- qdstat -g
   ```

## Dump Skupper details

From the namespace Skupper was deployed, debug dump details to a file. 

    skupper debug dump ~/tmp/skupper-dump.tar.gz

The contents will include:

* cluster version details
* skupper version details
* skupper configmap .yaml (skupper-site, skupper-services, skupper-internal, skupper-sasl-config)
* skupper deployment .yaml (skupper-router and skupper-service-controller)
* skupper-router deployment logs
* skupper-service-controller deployment logs
* qdstat (-g, -c, -l, -n, -e, -a, -m, -p) output

Note that The contents are stored in a compressed archive and if the filename
does not have an extension `.tar.gz` will be added.

## Skupper Service Controller get

The skupper-service-controller has a command interface to view events, check services
and view connected sites.

From the namespace Skupper was deployed, `get` command usage

    kubectl exec deploy/skupper-service-controller -- get --help

Show most recent events

    kubectl exec deploy/skupper-service-controller -- get events

Check configuration for an exposed service

    kubectl exec deploy/skupper-service-controller -- get servicecheck <address>

Show exposed services

    kubectl exec deploy/skupper-service-controller -- get services

Show connected sites

    kubectl exec deploy/skupper-service-controller -- get sites

## Skupper Resource Requirements

CPU and Memory request for skupper-router pod

    skupper init --router-cpu 2 --router-memory 1024m

CPU and Memory request for skupper-service-controller pod

    skupper init --controller-cpu 0.5 --controller-memory 512m