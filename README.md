Introduction
==============

This repository contains some example scripts for deploying a kubernetes cluster with wireguard enabled on worker nodes using terraform.

<span style="color:red">This is intended to be used for testing only, not suitable for production use.</span>

Table of contents
=================

<!--ts-->
   - [Introduction](#introduction)
   - [Table of contents](#table-of-contents)
   - [Purpose](#purpose)
   - [Prerequisites](#prerequisites)
   - [Cluster Deployment](#cluster-deployment)
   - [Outputs](#outputs)
   - [Connect And Test](#connect-and-test)
   - [Feedback](#feedback)
<!--te-->

Purpose
=================

Wireguard is a great piece of software and being able to spin up test kubernetes clusters with a vpn server built in is really useful for accessing pods and services within the cluster.

The terraform script will create a new kubernetes cluster in GCP and install the wireguard kernel module on all of worker nodes. Once this is complete a script will run to generate some wireguard keys and add a deployment with a ConfigMap with the wireguard configuration. 

Finally a client wireguard configuration will be written to a local file and also printed via QR code that you can easily scan with your mobile phone. 

Prerequisites
=================

1. Terraform (0.12.24) and google cloud sdk (289.0.0) installed.
2. `The GOOGLE_APPLICATION_CREDENTIALS` variable has been set to a json file with credentials in the google account to create resources.
3. You have created a unique storage bucket name and put that in the file `terraform/backend.tf`.


Cluster Deployment
=================

1. Run the `make` command which will execute a `terraform plan` and check the results.

This should look something like:
```
Initializing the backend...

Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.google: version = "~> 3.17"
* provider.google-beta: version = "~> 3.17"
* provider.null: version = "~> 2.1"

[...]

Plan: 10 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

This plan was saved to: ../data/plan.out

```


2. Run `make apply` to create the cluster and type `yes` to approve changes. 

The output should look something like:

```

Plan: 10 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:   yes

google_compute_firewall.wireguard-vpn: Creating...
google_container_cluster.primary: Creating...
google_compute_firewall.wireguard-vpn: Still creating... [10s elapsed]
google_container_cluster.primary: Still creating... [10s elapsed]

[...]

null_resource.deploy_wireguard (local-exec): deployment.apps/nginx-deployment created
null_resource.deploy_wireguard (local-exec): configmap/wireguard-config created
null_resource.deploy_wireguard (local-exec): service/wireguard-service created
null_resource.deploy_wireguard (local-exec): deployment.apps/wireguard-vpn created
null_resource.deploy_wireguard: Creation complete after 4s [id=5524856932275431232]
null_resource.qrcode-wireguard: Creating...
null_resource.qrcode-wireguard: Provisioning with 'local-exec'...
Executing: ["/bin/sh" "-c" "cat '../data/wireguard-client.conf' | qrencode -t utf8"]

█████████████████████████████████████████████████████████████████
█████████████████████████████████████████████████████████████████
████ ▄▄▄▄▄ █▀▄  ▀█▀▀▄▄▄ █▄▀▄▀▄▀██▄▀ ██▄█▄▄ ▀██ ▄▀▄▄ ██ ▄▄▄▄▄ ████
████ █   █ █▀█▄█  █ ▄  ██▀▀▄  █ █ ▀▀▀▄██▀ ▄▀ ▀▀ ▄█▄ ██ █   █ ████
████ █▄▄▄█ █▀▄█▀▄██▀ █▀██   █▀ ▄▄▄  █ ▄▄▄▀▄▄▀▀▀▄▄▄▀▄██ █▄▄▄█ ████
████▄▄▄▄▄▄▄█▄▀▄█▄█▄█ ▀ █▄█▄█▄█ █▄█ █▄▀ █ ▀ ▀▄▀▄▀▄▀▄▀ █▄▄▄▄▄▄▄████
████  ▄▄ █▄▄ ▄▀▄▀▀▄ ▀▀█▀▀ █▀▄▀ ▄▄▄ ██ ▀▄▀ ▄ █ ▄   ██▄▄█▄█▄█ █████
█████▄█ ▀█▄▀██▄█ ▀█▄█▄█▄█ ▄▀  ▀▄▀▄▀ ▀▀▄▀█▀▀▄▄▄ █▄ ▀▀ ▀▄▀▀ ▀▄▀████
████  ▀▀ █▄▄▀▄█ ▀▀█ ▄▄▀█▄ █▄ ▀█▄▄█ ▀█ ▀▀▀ ▄▄▄▄▀▀█▄▄█ █▀▀▀█▄ ▀████
████    █▀▄ ▀▄ ▄▀▄ ▄█▄ █▀▀█▄▄ ▀▄█▀▄█▀▀██ █ ▀█▀██  █ ▄█▀ █▄▄▀▄████
████ ▄   █▄  █▀▀█ ██▀█▀ █▀  ▄▄█▄  ▄▄▄ ▀▀  ▀█▄  ▀▄▀██ ▄▄ ██▀█▄████
████▀ █▄▄▀▄▀▄██ █▄ ▄▀ ▀ ██▄█ █▀▄▄ ▄█▀▄  ▄▀▄▀▄▄ ▀  █ ▄▀█▀▀▄▄ ▄████
█████  █ ▀▄█▀ ▄▄ ▄▄▀█▄ ▀█▄██▄█▄█▄ ▄▀▄▀▀▄▄▄███▄▄ █▀▀█▄▀▄█▄▀▀▀█████
████▀█ ▀  ▄█▀▀ ██▀▀▀█ ▀▄█▀█ ▄ █▄▄█ ██▄█▀ ▄ ▀██▄ █ ▄  ▀ ██▄█ █████
████▄ ▀▄▄▀▄█▄█▀  ███ ██▄▀█ ▄▀▄▀█▄ ▄▄██▄ ███▀▄  ▀▀█▄ █▄▀▄▄▄█▄█████
██████▀  ▄▄▄  █ █▀▀ █▀ ▄▀▀▄▄ ▀ ▄▄▄  █ ▄ ▀██▀ ▄ ▀▄ ██ ▄▄▄     ████
████ ▄ ▄ █▄█ █▀  ▀▀█▄▀ █▄ ▄▀▀  █▄█  ▄ █ ▀▄▄█▄█ ▀████ █▄█ ▀▀█▄████
██████▀█ ▄▄▄▄▀▀ █▄█▀▀█ ▀█ █▄ ▀   ▄▄  ▄▀▀▀█▄█▄ █▄▀▄▄▄▄ ▄ ▄ ▄▀▄████
████▄█ ▀▄█▄ ▀▄█▄ ▀▄▄▀ █▄▄▀▄█▄▀▄▄█▀ ▀█▀▀▀▀ ▀▀▄▀▄▀█▀██████▄  ▄█████
████ █▄▀▄ ▄ ▀▄▄█▄█▄▄█▀ ▄▀▄█▀  ▄▀▀█▄▀ █▀▀█▀▄██▀ ▄ ▄██   ██▄▄ █████
█████▄▄▀█ ▄ █▄ █ ▄ ▄▀▀▀▀█▄   ▀ ▀█▀ ▀█▀▀▀█▄▀▄  ▄▄▀█▀█ ▄█▀ ▀ ▀▄████
████▀▀▀▄█▀▄▀▀▀█▄█  ▄   ▄█▀█▀▄█▄ █▀▀█▄▄███ ▄█▄▄▄▀█ ▄▄▄▀▀ ██▄██████
████  ▄ ▄█▄▀█▀█▄█▄▀ ▀▀█▄  ▀▄▀▀█▀▀▄▀▄▀▄ ▀▄   █▄ ▀▀  ▄ ▀█▀▀▀▄▀█████
████▄▄ █  ▄ ▄▄█▄███ █▄█ █ █▄▄▄▄▀▀▀█▄▄ ▄▀▄█▄▀▀ ▄█▄███ ▄▀█▀▀▀▀▀████
████▄▀  ▀▄▄▄ █▄▄ █▀▄▀▄▀   █▀▀▀█▀▀▀▀▀▄  ▀ ▀  ▄▄  █▄█▄▄ ██▀▄█ █████
████ ▀ ▀▀▄▄ ▀  ▄ █ ██▄ ▀▀ ▄ ▄███▀█▄▄▄█▀ ▀▄▀▀█▀███  ▀▄▄ ██▄▄ ▄████
██████████▄▄  ▄ ▄▀▄▄▀█▀█▄▀▄ ██ ▄▄▄ ▀█▀▀▄▀ ██▄▄▄ █▀█▀ ▄▄▄ ▀▄█▀████
████ ▄▄▄▄▄ █▄▀█▀▄█▀ █  █████ ▀ █▄█ █ ▄▄▀▀▄▀▄█▀█ ▀ █▄ █▄█ ▄ ██████
████ █   █ █ ▄ █▄▀█▀█▀▀▀█  ▀█▀ ▄  ▄██▀▀▀▀▄█ █▄ ▄█▄▀▀▄ ▄  ▀███████
████ █▄▄▄█ █  ███▀▄▀█▀▀██▄▄▄  █▄▄█ ▀█▄▀ ▀ █▄█▄  █▀██▀█▀▀█ ▄██████
████▄▄▄▄▄▄▄█▄█▄█▄▄███▄█▄█▄████▄████▄█▄█▄▄▄█████▄█▄█████████▄█████
█████████████████████████████████████████████████████████████████
█████████████████████████████████████████████████████████████████


null_resource.qrcode-wireguard: Creation complete after 0s [id=4351088093696090442]

Apply complete! Resources: 10 added, 0 changed, 0 destroyed.
```


Once this is complete you have deployed your cluster with an ubuntu image and the wireguard kernel module added and loaded. A wireguard deployment with one replica exists and a sample nginx deployment with two pods has also been deployed.

You can easily connect to your new cluster using the QR code at the end of the deployment process.



Outputs
=================

In this example I create random keys for both the server and client in wireguard and use the IP range `192.168.4.0/24` for the vpn network and the default subnet for the pod and service addresses is set to: `10.50.0.0/16`. 

A directory called `data`  also exists with some useful files:

| Filename        | Description |
| ------------- | ----------------------------------|
| client-privatekey | wireguard private key for client |
| client-publickey | wireguard public key for client |
| kubeconfig | kubernetes config for new cluster |
| plan.out | terraform plan output |
| server-privatekey | wireguard private key for server |
| server-public  | wireguard public key for server |
| wireguard-client.conf | wireguard configuration file to connect to cluster |
| workers | list of kubernetes node pool workers |




Connect And Test
=================

To connect via linux/mac/windows use the `wireguard-client.conf` or for a qr code run `cat data/wireguard-client.conf | qrencode -t uft8`.

Now we can see our wireguard and nginx pods deployed:

```
$ kubectl get pods -o wide
NAME                                READY   STATUS    RESTARTS   AGE   IP          NODE                                        NOMINATED NODE   READINESS GATES
nginx-deployment-756d9fd5f9-rt5gw   1/1     Running   0          27m   10.50.1.8   gke-k8s-wireguard-node-pool-96187f03-z1rv   <none>           <none>
nginx-deployment-756d9fd5f9-w8ltr   1/1     Running   0          27m   10.50.2.9   gke-k8s-wireguard-node-pool-96187f03-cd09   <none>           <none>
wireguard-vpn-688df8df7c-cnsqc      1/1     Running   0          27m   10.50.2.8   gke-k8s-wireguard-node-pool-96187f03-cd09   <none>           <none>
```

Test connectivity to both nginx pods:

```
$ nc -vz 10.50.1.8 80
Connection to 10.50.1.8 80 port [tcp/http] succeeded!
$ nc -vz 10.50.2.9 80
Connection to 10.50.2.9 80 port [tcp/http] succeeded!
```

Trace to pod on the same node as the wireguard pod:
```
$ traceroute 10.50.2.9
traceroute to 10.50.2.9 (10.50.2.9), 30 hops max, 60 byte packets
 1  192.168.4.1 (192.168.4.1)  27.181 ms  27.638 ms  27.640 ms
 2  10.50.2.9 (10.50.2.9)  27.623 ms  27.744 ms  27.729 ms
```

Trace to pod on a different node as the wireguard pod where the traffic is forwarded:

```
$ traceroute 10.50.1.8
traceroute to 10.50.1.8 (10.50.1.8), 30 hops max, 60 byte packets
 1  192.168.4.1 (192.168.4.1)  26.849 ms  28.048 ms  28.033 ms
 2  10.50.2.1 (10.50.2.1)  27.996 ms  27.857 ms  27.813 ms
 3  * * *
 4  10.50.1.8 (10.50.1.8)  27.943 ms  28.894 ms  28.857 ms
```



Feedback
=================

Feedback welcome via Issues or Pull Requests.



