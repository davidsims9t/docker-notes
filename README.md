# Docker & Kubernetes Notes

## Table of Contents

- [Hypervisor-based Virtualization](#hypervisor-based-virtualization)
- [Container Based](#container-based)
- [Docker Client](#docker-client)
- [Docker Concepts](#docker-concepts)
- [Commands](#commands)
- [Docker Ports & Logging](#docker-ports--logging)
- [Docker Images](#docker-images)
- [Ways to Build an Image](#ways-to-build-an-image)
- [Dockerfile](#dockerfile)
- [Chain Run Command](#chain-run-command)
- [Sort Multi-Lines Arguments Alphanumerically](#sort-multi-lines-arguments-alphanumerically)
- [CMD](#cmd)
- [Push Images to DockerHub](#push-images-to-dockerhub)
- [Containerization An Application](#containerize-an-application)
- [Docker Container Links](#docker-container-links)
- [Docker Compose](#docker-compose)
- [Docker Networking](#docker-networking)
- [Unit Tests in Containers](#unit-tests-in-containers)
- [Continuous Integration](#continuous-integration)
- [Running in Production](#running-in-production)
- [Kubernetes](#kubernetes)
- [MiniKube](#minikube)
- [Kops](#kops)
- [Load Balancers](#load-balancers)
- [Basics](#basics)
- [Scaling](#scaling)
- [Labels](#labels)
- [Node Labels](#node-labels)
- [Health Checks](#health-checks)
- [Secrets](#secrets)
- [Web UI](#web-ui)
- [Ingress](#ingress)
- [Advanced Topics](#advanced-topics)
- [Config Map](#config-map)
- [Volumes](#volumes)
- [Volume Provisioning](#volume-provisioning)
- [Pet Sets](#pet-sets)
- [Daemon Sets](#daemon-sets)
- [Autoscaling](#autoscaling)
- [Resource Management](#resource-management)
- [Namespaces](#namespaces)
- [User Management](#user-management)
- [Networking](#networking)
- [Node Maintenance](#node-maintenance)
- [High Availability](#high-availability)

## Hypervisor-based Virtualization

- Physical Server
- Host OS
- Hypervisor
  - Debian
    - Libs/bins
  - Ubuntu
    - Libs/bins

### Benefits

- Cost effective
- Easy to Scale

### Limitations

- Kernel Resource Duplication
- Application Portability Issue

## Container-based

Containers share the same kernel resource.

### Runtime Isolation

- Uses only the minimal requirements
- Allows for fast deployment
- Guaranteed Portability

Example:

- Application A - Container A
  - JRE 8
  - JVM
- Application B - Container B
  - JRE 7

## Docker Client

docker build - Docker daemon
docker pull - Docker daemon
docker run - Docker daemon

Docker Daemon -> Registry (Redis) -> Redis Image
Image -> Container

Docker Daemon

Docker engine - run on remote docker daemon or local.

## Docker Concepts

### Images

- Images are read as templates used to create containers.
- Images are created with the docker build command, either by us or by other docker users.
- Images are composed of layers of other images.
- Images are stored in Docker registry.

### Containers

- If an image is a class, then a container is an instance of a class - a runtime object.
- Containers are lightweight and portable encapsulations of an environment in which to run programs.
- Containers are created from images. Inside a container, it has all the binaries and dependencies needed to run the application.

### Registries and Repositories

- A registry is where we store our images.
- You can host your own registry, or you can use Docker public registry which is called DockerHub.
- Inside a registry, images are stored repositories.
- Docker repository is a collection of different docker images with the same name, that have different tags, each tag usually means a different version of the image.
- DockerHub is a popular service for repositories.
- Official names are reviewed by DockerHub.
- If you don't specify a tag, it defaults to latest.
- Docker will use the local image first if it's available, otherwise it will download it from the network.

## Commands

To list available images use:

```
docker images
```

To use an image to echo "hello world":

```
docker run image echo "hello world"
```

Use -i -t for interactive.

To view currently running Docker containers use:

```
docker ps
```

To use all previous ran containers use -a.

To remove a container use:

```
docker run image --rm
```

To name a container use --name.

Use -d to run in detached mode.

To view low-level docker container information use:

```
docker inspect
```

## Docker Ports & Logging

To run docker on a specific port use:

```
docker run -it -p host_port:container_port tomcat:8.0
```

To view logs from a container use:

```
docker logs container_id
```

## Docker Images

Docker images contain a series of layers. To see the layers an image has use:

```
docker history image
```

1. All changes made to a running containers will be written to a writable layer.
2. When the container is deleted, the writable layer is also deleted, but the underlying image remains unchanged.
3. Multiple containers can share access to the same underlying image.

## Ways to Build an Image

1. Create a Dockerfile.
2. Commit changes made to a Docker container.

To commit your Docker changes use:

```
docker commit container_id repository_name:tag
```

## Dockerfile

To install an image use:

```
FROM image
```

To run a command use:

```
RUN apt-get update
```

To build a container from a Dockerfile use:

```
docker build
```

- Optionally you can specify the build context.
- When the build starts the build context gets saved to a tarball.
- The tarball is then transferred to the daemon.

## Chain Run Command

- Each run command executes on the top writeable layer and then commits the change.
- The new image is then used for the next step in the Dockerfile.
- Each run command creates a new image layer.
- Its recommended to chain the run commands to minimize the new image layers.

## Sort Multi-Lines Arguments Alphanumerically

- This will help you avoid duplication.

## CMD

- Specifies which command to run when the container starts.
- If we don't specify the CMD command in the Dockerfile, Docker will use the default command from the image.
- The CMD instruction doesn't run when building the image.
- You can specify the command in either exec form or shell form.

## Push Images to DockerHub

- List docker images by using:

```
docker images
```

- In order to push the image you must first link the image to a Docker account.
- Name the repository something like username/repo
- To push a repo use:

```
docker tag hash_id username/repo
```

## Latest Tag

- Docker will use latest as a default tag when no tag is provided.
- A lot of repositories use it to tag the most up-to-date stable image, however,
this is still only a convention and is entirely not enforced.
- Images which are tagged latest will not be updated automatically when a newer version of the image is pushed to the repository.
- Avoid using latest tag.

### Login

To login use:

```
docker login --username=dsims
```

To push your repo use:

```
docker push username/repo
```

## Containerize An Application

To build the container use:

```
docker build -t dockerapp:v1.0 .
```

To run docker container use:

```
docker run -d -p 5000:5000 image_id
```

To find out where the docker container is running use:

```
docker-machine ls
```

To run a command inside a container use:

```
docker exec -it image_id bash
```

## Docker Container Links

Allows containers to communicate with each other. Requires a recipient container (i.e. Dockerapp) and a source container (i.e. Redis).

First run the container with:

```
docker run -d --name redis redis:3.2.0
```

Then run the Dockerapp container by using:

```
docker run -d -p 5000:5000 --link redis dockerapp:v0.3
```

Benefits of Docker Container Links:

- When you build an application with a micro-service architecture, it allows to run many
independent applications in different containers to connect with one another.
- Creates a secure tunnel between containers that doesn't need to expose any ports externally.

## Docker Compose

- Manual linking containers doesn't make sense when there's a lot of different containers (20+).
- Docker Network allows all services to connect to each other.
- Removes the burden of maintaining scripts for Docker orchestration.

To start docker services use:

```
docker-compose up
```

To view Docker compose logs use:

```
docker-compose logs
```

To stop Docker containers use:

```
docker-compose stop
```

To remove all Docker containers use:

```
docker-compose rm --all
```

To force a rebuild of an image use:

```
docker-compose build
```

## Docker Networking

Each container connects to a bridge network to connect to the host machine.

### Docker Network Types

- Closed Network / None Network
- Bridge Network
- Host Network
- Overlay Network

To see Docker networks use:

```
docker network ls
```

### None Network

It's an isolated container that has no connection to the outside world.

To run a closed network use:

```
docker run -d --net none image
```

- Provides the maximum level of network protection.
- Not a good choice if network or Internet connection is required.
- Suites well when the container requires maximum level of security.

### Bridge Network Interface

To create a network use:

```
docker network create --driver bridge my_bridge_network
```

To inspect a network use:

```
docker network inspect my_bridge_network
```

To disconnect from a network use:

```
docker network disconnect bridge container_3
```

- In a bridge network containers have access to 2 network interfaces (loopback and private).
- All containers in the same network can communicate with each other.
- Containers from different bridge networks can't connect with each other by default.

### Host Network

- Least protected network model, add container to host network.
- Containers hosted on host network have full access to host's interface.
- These containers are called open containers.
- No isolation.
- Host containers have best performance.

### Overlay Network

- Supports multi-host networks out-of-the-box.
- Require some pre-existing conditions before it can be created (running in swarm mode).

### Define Network in Compose

By default it sets a single network.

## Unit Tests in Containers

- Should test some functionality in a container without any outside resources.
- Should run quickly as possible to avoid being blocked.
- Spin up quick and provide a clean and isolated environment for unit tests.

To run a service inside of a container use:

```
docker-compose run dockerapp python test.py
```

Pros:
- A single image is used throughout development and production. Increases reliability.

Cons:
- Increases size of the image.

## Continuous Integration

- Isolated changes are immediately tested and reported when they're added to a larger code base.
- Provides rapid feedback so if a bug is introduced it will be identified as soon as possible.

### Configuring Circle CI

Set DockerHub credentials in Circle CI by going to Project > Settings > Build Settings > Environmental Variables.

Then set:

```
DOCKER_HUB_EMAIL
DOCKER_HUB_PWD
DOCKER_HUB_USER_ID
```

To their respective DockerHub credentials.

### Tag the Docker Images with Two Tags

1. Git commit hash of the source code.
2. Latest

## Running In Production

Concerns:

- There are some missing pieces about Docker around data persistence, networking, security, and identity management.
- The ecosystem to support monitoring and logging are not still fully ready yet.

A lot of companies are already using Docker in production.

### Why Run It In a VM?

- To address security concerns
- Hardware level isolation

Amazon EC2 still uses VMs internally

### Docker Machine

- Can provision new VMs
- Install Docker Engine
- Configure Docker Client

### Creating a New VM

To create a new Docker VM use:

```
docker-machine create --driver digitalocean --digitalocean-access-token tag docker-app-machine
```

To setup the Docker environment use:

```
docker-machine env docker-app-machine
```

Then to see the environment variable use:

```
eval $(docker-machine env docker-app-machine)
```

### Production deployment

```
docker-compose -f prod.yml up
```

### Extends keyword

- Allows for sharing of common configurations among different files or projects.
- Can be useful if you have several different environments that re-use most configuration options.

Use:

```
extends:
  file: common.yml
  service: redis
```

### Docker Swarm

- A tool that clusters many Docker Engines and scheduled containers.
- Decides which host to run the container based on scheduling methods.

Set Digital Ocean configuration information by using:

```
export DIGITALOCEAN_ACCESS_TOKEN=
export DIGITALOCEAN_PRIVATE_NETWORKING=true
export DIGITALOCEAN_IMAGE=
```

### Service Discovery

- Key component of most distributed systems and service oriented architectures.
- In the context of Docker Swarm, service discovery is about how the Swarm Manager keeps track of the state of all the nodes in a cluster.

### Deploy Docker App In a Swarm Cluster

1. Provision a consul machine and run machine as a key-value store for service discovery.
2. Provision a Docker swarm master node.
3. Provision a Docker swarm slave node.
4. Define the overlay network to support multi-host networking.
5. Deploy out Docker app services on the Swarm cluster via Docker compose.

To display the network configuration use:

```
docker-machine ssh consul ifconfig
```

To ping the private and public IPs use:

```
ping -c 1 $(docker-machine ssh consul 'ifconfig eth0 | grep "inet addr:" | cut -d: -f2 | cut -d" " -f1')
ping -c 1 $(docker-machine ssh consul 'ifconfig eth1 | grep "inet addr:" | cut -
```

To configure Docker client to connect to consul use:

```
eval $(docker-machine env consul)
```

To create a Swarm master node use:

```
docker-machine create -d digitalocean --swarm --swarm-master --swarm-discovery="consul://${KP_IP}:8500" --engine-opt="cluster-store=consul://${KP_IP}:8500" --engine-opt="cluster-advertise=eth1:2376" master
```

To create slave nodes use:

```
docker-machine create -d digitalocean --swarm --swarm-discovery="consul://${KP_IP}:8500" --engine-opt="cluster-store=consul://${KP_IP}:8500" --engine-opt="cluster-advertise=eth1:2376" slave
```

## Kubernetes

Is an open-source orchestration system for Docker containers.

- Lets you schedule containers on a cluster of machines
- You can run multiple containers on one machine
- You can run long running services (like web applications)
- Managed the state of these containers
  - Can start container on specific nodes
  - Will restart a container when it gets killed
  - Can move containers from one node to another node

- Instead of running a few docker containers manually. Kubernetes manages it for you.
- Clusters can start with one node until thousands of nodes
- Some other popular docker orchestrations are:
  - Docker Swarm
  - Mesos

Kubernetes:
  - On-premise
  - Public (AWS)
  - Hybrid: public & private

- Highly modular
- Open source
- Backed by Google

Docker Engine

- Docker runtime
- Software to run docker images

Docker Hub

- Online service to store and fetch docker images
- Also allows you to build docker images online

Kubernetes can be ran anywhere (except more integrations exists for AWS/GCE)

- Things like Volumes and External Load Balancers work only with supported Cloud Providers
- Minikube - run Kubernetes locally
- Kops - used to spin up highly available production cluster

### MiniKube

Starting MiniKube:

```
minikube start
```

MiniKube config:

```
cat ~/.kube/config
```

Expose minikube test:

```
kubectl expose deployment hello-minikube --type=NodePort
```

Run minikube service:

```
kubectl run hello-minikube --image=gcr.io/google_containers/echoserver:1.4 --port=8080
minikube service hello-minikube --url
```

Stop minikube:

```
minikube stop
```

### Kops

Virtual Machine setup:

```
vagrant init ubuntu/xenial64
```

Virtual Machine run:

```
vagrant up
```

Download Kops on Machine:

```
brew update && brew install kops
```

Install AWS CLI using pip. Create Kops user on AWS and give it Administrative Access.

Create a subdomain using Route53 for Kubernetes: (kubernetes.domain.com).

To create a kops cluster use:

```
kops create cluster --name=kubernetes.domain.com --state=s3://kobs-state-blah --zones=eu-west-1a --node-count=2 --node-size=t2.micro --master-size=t2.micro --dns-zone=kubernetes.domain.com
```

To configure the cluster use:

```
kops update cluster kubernetes.domain.com --yes
```

To edit the cluster use:

```
kops edit cluster kubernetes.domain.com
```

Or

```
kops edit cluster kubernetes.domain.com --state=s3://kops-state-blah
```

Docker/Kubernetes Remarks:

- You should only run one process in one container
  - Don't try to create one giant docker image for your app, split it up if necessary.
- All the data in the container is not preserved, when a container stops, all the changes within a container are lost.
  - You can preserve data, using volumes, which is covered later in this course

- A pod describes an application running on Kubernetes.
- A pod can contain one or more tightly coupled containers, that make up the app.
- Those apps can easily communicate with each other using their local port numbers.
- Our app only has one container.
- Create pod-helloworld.yml

```
apiVersion: v1
kind: Pod
metadata:
  name: nodehelloworld.example.com
  labels:
    app: helloworld
spec:
  containers:
  - name: k8s-demo
    image: my-image
  ports:
  - name: nodejs-port
  - containerPort: 3000
```

To create a pod-helloworld.yml with the pod definition use:

```
kubectl create -f k8s-demo/pod-helloworld.yml
```

Useful commands:

```
kubectl get pod - Get information about all running pods
kubectl describe pod <pod> - Describe one pod
kubectl expose pod <pod> --port=444 --name=frontend - Expose the port of a pod (creates a new service)
kubectl port-forward <pod> 8080 - Port forward the exposed post port to your local machine
kubectl attach <podname> -i - Attach to the pod
kubectl exec <pod> -- command - Execute a command on the pod
kubectl label pods <pod> mylabel=awesome - Add a new label to a pod
kubectl run -i --tty busybox --image=busybox --restart=Never -- sh - Run a shell in a pod - very useful for debugging
```

### Load Balancers

On AWS the load balancer will route the traffic to the correct pod in Kubernetes.

You can use haproxy or nginx load balancer in front of your cluster. Expose port directly.

To setup a service with a load balancer use:

```
apiVersion: v1
kind: Service
metadata:
  name: helloworld-service
spec:
  ports:
  - port: 80
    targetPort: nodejs-port
    protocol: TCP
  selector:
    app: helloworld
type: LoadBalancer
```

### Basics

Internet traffic is directed to a load balancer which then does a look-up on the iptables. IPTables then directs traffic to pods containing Docker containers. Kubelet/kube-proxy also does a look-up against iptables.

### Scaling

If your application is stateless then you can horizontally scale it.

- Stateless means that it doesn't write any local files or keep local sessions.
- All traditional databases (MySQL/Postgres) are stateful, they have database files that can't be split over multiple instances.

Most web applications can be made stateless.

- Session management needs to be done outside the container.
- Scaling in Kubernetes can be done using the Replication Controller.
- The replication controller will ensure a specified number of pod replicas will run at all time.
- A pods created with the replica controller will automatically be replaced if they fail, get deleted, or are terminated.
- Using the replication controller is also recommended if you just want to make sure 1 pod is always running, even after reboots
  - You can then run a plication controller with just 1 replica
  - This makes sure that the pod is always running

To replicate an app 2 times using the Replication controller:

```
apiVersion: v1
kind: ReplicationController
metadata:
  name: helloworld-controller
spec:
  replicas: 2
  selector:
    app: helloworld
  template:
    metadata:
      labels:
        app: helloworld
    spec:
      containers:
      - name: k8s-demo
        image: k8s-demo
        port:
        - containerPort: 3000
```

Via CLI you can use:

```
kubectl scale --replicas=4 -f config.yml
```

Replication Set

- Replica Set is the next-generation Replication Controller
- It supports a new selector that can do selection based on filtering according to a set of values
  - "environment" can be "dev" or "qa"
  - not based on equality

- Replica Set is used by Deployment object

- A deployment declaration in Kubernetes allows you to do app deployments and updates
- When using the deployment object, you define the state of your application
  - Kubernetes will then make sure the clusters matches your desired state
- Using the replication controller or replication set might be cumbersome to deploy apps
  - The Deployment Object is easier to use and gives you more possibilities

With a deployment object you can:

- Create a deployment (deploy an app)
- Update a deployment (deploy a new version of an app)
- Rolling updates (zero downtime deployments)
- Roll back to a previous version
- Pause/resume a deployment (e.g. to roll-out to only a certain percentage)

Example deployment:

```
apiVersion: v1
kind: Deployment
metadata:
  name: helloworld-deployment
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: helloworld
    spec:
      containers:
      - name: k8s-demo
        image: k8s-demo
        ports:
        - containerPort: 3000
```

Useful commands:

```
kubectl get deployments - Get information on current deployments
kubectl get rs - Get information about replica sets
kubectl get pods --show-labels - get pods, and also show labels attached to those pods
kubectl rollout status deployment/helloworld - Get deployment status
kubectl set image deployment/helloworld k8s-demo=k8s-demo:2 - Run k8s-demo with image label version 2
kubectl edit deployment/helloworld-deployment - Edit the deployment object
kubectl rollout status deployment/helloworld-deployment - Get status of the rollout
kubectl rollout history deployment/helloworld-deployment - Get the rollout history
kubectl rollout undo deployment/helloworld-deployment - Rollback to previous version
kubectl rollout undo deployment/helloworld-deployment --to-revision=n - Rollback to any version
```

### Services

- Pods are very dynamic, they come and go on the Kubernetes cluster
  - When using a Replication Controller, pods are terminated and created during scaling operations
- When using Deployments, when updating the image version, pods are terminated and new pods take the place of older pods
- A service is the logical bridge between the "mortal" pods and other services or end-users
- kubectl expose creates a new service for your pod.
- Creating a service will create an endpoint for your pod(s):
  - A ClusterIP: a virtual IP address only reachable from within the cluster
  - A NodePort: a port that is the same on each node that is reachable externally
  - A LoadBalancer: a LoadBalancer created by the cloud provider that will route external traffic to every node on the NodePort (ELB on AWS)
- The options just shown only allow you to create virtual IPs or ports
- There is also a possibility to use DNS names
  - ExternalName can provide a DNS name for the service
  - e.g. for service discovery using DNS
  - This only works when the DNS add-on is enabled

Example Service definition:

```
apiVersion: v1
kind: Service
metadata:
  name: helloworld-service
spec:
  ports:
  - port: 31001
    nodePort: 31001
    targetPort: nodejs-port
    protocol: TCP
  selector:
    app: helloworld
  type: NodePort
```

Default services can only run between ports 30000 - 32767, but you can change this behavior by using --service-node-port-range= to kube-apiserver.

### Labels

- Key/value pairs that can be attached to objects
  - Labels are like tags in AWS or other cloud providers, used to tag resources
- You can label your objects, for instance your pod.
  - Key: env - Value: dev / qa
  - Key: department - Value: engineering
- Labels are not unique and multiple labels can be added to one object
- Once labels are attached to an object, you can use filters to narrow down results (Label Selectors)
- Using Label Selectors, you can use matching expressions to match labels
  - For instance, a particular pod can only run on a node labeled with "env": "dev"
- More complex matching: "env": "dev" or "qa"

### Node Labels

- You can also use labels to tag nodes
- Once nodes are tagged, you can use label selectors to let pods only run on specific nodes
- There are 2 steps required to run a pod on a specific set of nodes:
  - First you tag the node
  - Then you add a nodeSelector to your pod configuration

To add a label use:

```
kubectl label nodes node1 hardware=high-spec
kubectl label nodes node2 hardware=low-spec
```

Then add a pod that uses those labels:

```
apiVersion: v1
kind: Pod
metadata:
  name: helloworld-service
  labels:
    app: helloworld
spec:
  containers:
  - name: k8s
    image: k8s
    ports:
    - containerPort: 3000
  nodeSelector:
    hardware: high-spec
```

### Health Checks

- If your application malfunctions, the pod and container can still be running, but the application might not work anymore.
- To detect and resolve problems with your application, you can run health checks.
- You can run 2 different type of health checks
  - Running a command in the container periodically
  - Periodic checks on a URL (HTTP)
- The typical production application behind a load balancer should always have health checks implemented in some way to ensure availability and resiliency of the app.

Example of health checks:

```
apiVersion: v1
kind: Pod
metadata:
  name: nodehelloworld.example.com
  labels:
    app: helloworld
spec:
  containers:
  - name: k8s
    image: k8s
    ports:
    - containerPort: 3000
    livenessProbe:
      httpGet:
        path: /
        port: 3000
      initialDelaySeconds: 15
      timeoutSeconds: 30
```

### Secrets

- Secrets provides a way in Kubernetes to distribute credentials, keys, passwords or "secret" data to the pods.
- Kubernetes itself uses this Secrets mechanism to provide the credentials to access the internal API.
- You can also use the same mechanism to provide secrets to your application.
- Secrets is one way to provide secrets, native to Kubernetes.
  - There are still other ways your container can get its secrets if you don't want to use Secrets (e.g. using an external vault service)
- Can be used as environment variables.
- Use secrets as a file in a pod
  - This setup uses volumes to be mounted in a container
  - In this volume you have files
  - Can be used for instance for dotenv files or your app can just read this file
- Use an external image to pull secrets (from a private image registry)

To generate secrets using files:

```
kubectl create secret generic db-user-pass --from-file=./username.txt --from-file=./password.txt
```

A secret can also be generated from an SSH key or SSL certificate:

```
kubectl create secret generic ssl-certificate --from-file=ssh-privatekey=~./ssh/id_rsa --ssl-cert-=ssl-cert=mysslcert.crt
```

To generate secrets using yaml definitions:

secrets-db-secret.yml

```
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  password:
  username:
```

Then use:

```
kubectl create -f secrets-db-secret.yml
```

Using secrets:

```
spec:
  env:
    - name: SECRET_USERNAME
    valueFrom:
      secretKeyRef:
        name: db-secret
        key: username
    - name: SECRET_PASSWORD
```

Or:

```
spec:
  volumeMounts:
  - name: credvolume
    mountPath: /etc/creds
    readOnly: true
  volumes:
  - name: credvolume
    secret:
      secretName: db-secrets
```

### Web UI

- Kubernetes comes with a Web UI you can use instead of the kubectl commands
- Get an overview of your cluster
- Creating and modifying individual Kubernetes settings
- If a password is asked you can retrieve the password by using:

```
kubectl config view
```

To launch the dashboard:

```
minikube dashboard
```

### Advanced Topics

#### Service Discovery

As of Kubernetes 1.3 DNS is built-in that's launched automatically.

- The addons are in the /etc/kubernetes/addons directory on master node.
- The DNS service can be used within pods to find other services running on the same cluster
- Multiple containers within 1 pod don't need this service, as they can contact each other directly
- A container in the same pod can connect the port of the other container using localhost:port.
- To make DNS work, a pod will need a Service definition

You only need the name of the service to get back the IP address of the pod so long as they're in the same namespace.

### Config Map

- Configuration parameters that are not secret, can be put in a ConfigMap.
- The input is key - value pairs.
- The ConfigMap key-value pairs can then be read by the app using:
  - Environment variables
  - Container command-line arguments
  - Using volumes
- The ConfigMap can also contain full configuration files
- This file can be mounted using volumes where the application expects its config file
- This way you can inject configuration settings into containers without changing the container itself

To generate configmap using files:

```
cat <<EOF > app.properties
driver=jdbc
database=postgres
lookandfeel=1
otherparams=xyz
param.with.hierarchy=xyz
EOF
```

```
kubectl create configmap app-config --from-file=app.properties
```

```
spec:
  containers:
  volumeMounts:
  - name: config-volume
    mountPath: /etc/config
  volumes:
  - name: config-volume
    configMap:
      name: app-config
  env:
    - name: DRIVER
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: driver
    - name: DATABASE
```

To return the ConfigMap use:

```
kubectl get configmap app-config
```

### Ingress

- Allows inbound connections to the cluster
- It's an alternative to the external LoadBalancer and nodePorts
  - Allows you to easily expose services that need to accessible from outside the cluster
- With Ingress you can run your own ingress controller (basically a loadbalancer) within the Kubernetes cluster
- There are default Ingress controllers available, or you can write your own ingress controller

Scenario:

Internet -> Ingress Controller (NGINX) -> pod 1
Internet -> Ingress Controller (NGINX) -> pod 2

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: helloworld-rules
spec:
  rules:
  - host: helloworld-v1.example.com
    http:
      paths:
        - path: /
          backend:
            serviceName: helloworld-v1
            servicePort: 80
```

### Volumes

- Volumes in Kubernetes allow you to store state outside the container
- When a container stops, all data on the container itself is lost
- Persistent volumes in Kubernetes allow you to attach a volume to a container that will exist even when the container stops

Volumes can be attached using different volume plugins.

Containers in a pod can be used to attach a volume.

Using volumes you could deploy applications with state on your cluster, such as:

- Applications that need to read/write on the local file system that need to be persistent in time
- You could run MySQL using persistent volumes
- Volume can be attached to a new node if the original node is destroyed

To remove the volume from the pod use:

```
kubectl drain pod
```

To create an AWS EC2 volume use:

```
aws ec2 delete-volume --volume-id vol-hash
```

### Volume Provisioning

- The Kubernetes plugin allows you to provision storage for you
- The AWS Plugin can for instance provision storage for you by creating the volumes in AWS before attaching them to a node
- This is done using the StorageClass Object
- To use the auto provisioned volumes you can create storage.yml:

```
kind: StorageClass
apiVersion: storage.k8s.io/v1beta
metadata:
  name: standard
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
  zone: us-east-1
```

Volume Claim:

```
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: myclaim
  annotations:
    volume.beta.kubernetes.io/storage-class: "standard"
  spec:
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: 8Gi
```

To launch the pod use:

```
kind: Pod
apiVersion: v1
metadata:
  name: mypod
spec:
  containers:
    - name: myfrontend
      image: nginx
      volumeMounts:
        - mountPath: "/var/www/html"
          name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: myclaim
```

### Pet Sets

- New feature in v1.3 alpha
- Introduce to create stateful application that need:
  - A stable pod hostname
    - Your podname will have an index when having multiple instances of a pod
  - A stateful app that requires multiple pods with volumes based on their ordinal number (podname-x)
    - Currently deleting and/or scaling a PetSet down will not delete the volumes associated with the PetSet.

- A pet set will allow your stateful app to use DNS to find other peers
  - Cassandra clusters, Elasticsearch clusters, use DNS to find other members of the cluster
- One running node of your Pet Set is called a Pet (e.g. one node in Cassandra).
- Using Pet Sets you can run for instance 5 cassandra nodes on Kubernetes named cassandra-1 until cassandra-5
- If you wouldn't use Pet Sets, you would get a dynamic hostname, which you wouldn't be able to use it in your configuration file.

- A pet set will also allow your stateful application to order your start-up and tear-down of the pets.
  - Instead of randomly terminating one Pet, you'll know which one goes
  - This is useful if you first need to drain the data from a node before it can be shut down

### Daemon Sets

- Daemon sets ensure that every single node in the cluster in the Kubernetes cluster runs the same pod resource.
  - This is useful if you want to ensure that a certain pod is running on every single Kubernetes node.
- When a node is added to the cluster, a new pod will be started on that automatically.
- Same when the node is removed, the pod will not be rescheduled on another node.

Typical use cases:

- Logging aggregators
- Monitoring
- Load Balancers / Reverse Proxies / API Gateways
- Running a daemon that only needs one instance per physical instance

```
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: monitoring-agent
  labels:
    app: monitoring-agent
spec:
  template:
    metadata:
      labels:
        name: monitoring-agent
    spec:
      containers:
      - name: k8s
        image: k8s
        ports:
          - name: nodejs-port
            containerPort: 3000
```

### Resource Usage Monitoring

- Heapster enables container cluster monitoring and performance analysis
- It provides a monitoring platform for Kubernetes
- It's a prerequisite if you want to do pod auto-scaling
- Heapster exports cluster metrics via REST endpoints
- You can use different backends with Heapster
- Visualizations can be shown using Grafana
  - The Kubernetes dashboard will also show graphs once monitoring is enabled
- All can be started in pods

Heapster (https://github.com/kubernetes/heapster)

### Autoscaling

- Kubernetes has the possibility to automatically scale pods based on metrics
- Kubernetes can automatically scale a Deployment, ReplicationController, or Replica
- In Kubernetes 1.3 scaling based on CPU usage is possible out of the box
  - With alpha support, application based metrics are also available (like queries per second or average request latency)
    - To enable this, the cluster has to be started with the env var ENABLE_CUSTOM_METRICS to true
- Autoscaling with periodically query the utilization for the targeted pods
  - By default it is every 30 seconds, but can be changed using 'horizontal-pod-scaler-sync-period'
    when launching the controller-manager
- Autoscaling will use heapster, the monitoring tool, to gather its metrics and make scaling decisions
- Run a deployment with a pod with a CPU resource request of 200m
  - 200m = 200 millicpu (20% single CPU core of a node)
- Horizontal Pod Autoscaling will increase/decrease pods to maintain a target CPU utilization of 50%

```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: hpa-example
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: hpa-example
  spec:
    containers:
    - name: hpa-example
      image: gcr.io/google_containers/hpa-example
      ports:
      - name: http-port
        containerPort: 80
      resources:
        requests:
          cpu: 200m
```

```
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: hpa-example-autoscaler
spec:
  scaleTargetRef:
    apiVersion: extensions/v1beta1
    kind: Deployment
    name: hpa-example
  minReplicas: 1
  maxReplicas: 10
  targetCPUUtilizationPercentage: 50
```

### Resource Management

- When a Kubernetes cluster is used by multiple people or teams, resource management becomes more important.
  - You want to be able to manage the resources you give to a person or a team
  - You don't want the person or team taking up all the resources
- You can divide your cluster into namespaces and enable resource quotas on it
  - You can do this using the ResourceQuota and ObjectQuota objects
- Each container can specify request capacity and capacity limits
  - Resource capacity is an explicit request for resources
    - The scheduler can use the request capacity to make decisions where to put the pod on
    - You can set it as a minimum amount of resources the pods need
  - Resource limit is a limit imposed to the container
    - The container will not be able to utilize more resources than specified

Example Resource Quotas:

- You run a deployment with a pod with a CPU resource request of 200m
- 200m = 200 millicpu (200 millicores)
- 200m = 0.2 (20% of CPU core)
- Memory quotas as defined as MiB or GiB
- If a capacity quota (e.g. mem/cpu) has been specified by the administrator, then each
pod needs to specify capacity quota during creation
  - The administrator can specify default request values for pods that don't specify any values for
capacity
  - The same for valid limit quotas
- If a resource is requested more than allowed capacity, the server API will give a 403 forbidden error

#### Set Resource Quotas

requests.cpu - the sum of all CPU requests can exceed this value
requests.mem - The sum of all MEM requests of all pods cannot exceed this value
requests.storage - The sum of storage requests of all persistent volume claims cannot exceed this value
limits.cpu - The sum of the CPU limits of all pods cannot exceed this value
limits.memory - The sum of MEM limits of all pods cannot exceed this value

The administrator can set the following objects:

configmaps - total number of configmaps that can exist in a namespace
persistentvolumeclaims - total number of persistent volume claims that can exist in a namespace
pods - total number of pods that can exist in a namespace
replicationcontrollers - total number of replicationcontrollers that exist in a namespace
resourcequotas - total number of resource quotas that can exist in a namespace
services - total number of services that exist in a namespace
services.loadbalancer - total number of load balancers that can exist in a namespace
services.nodeports - total number of node ports that can exist in a namespace
secrets - total number of secrets that can exist in a namespace

### Namespaces

- Namespaces allow you to create virtual clusters within the same virtual cluster
- Namespaces logically separates your cluster
- The standard default namespace is called default and that's where all resources are launched by default
  - There is also a namespace for kubernetes specific resources, called kube-system
- Namespaces are intended when you have multiple teams / projects using the same cluster
- The name across resources need to be unique within a namespace, but not across namespaces
- You can limit resources on a per namespace basis

To create a namespace:

```
kubectl create namespace myspace
```

To get namespaces use:

```
kubectl get namespaces
```

You can set the default namespace using:

```
export CONTEXT=$(kubectl config view | awk '/current_context/ {print $2}')
kubectl config set-context $CONTEXT --namespace=myspace
```

Then to create the resource limits within that namespace:

```
apiVersion: v1
kind: ResourceQuota
metadata:
  name: computer-resources
  namespace: myspace
spec:
  hard:
    requests.cpu: "1"
    requests.memory: 1Gi
    limits.cpu: "2"
    limits.memory: 2Gi
```

Create object limits:

```
apiVersion: v1
kind: ResourceQuota
metadata:
  name: object-counts
  namespace: myspace
spec:
  hard:
    configmaps: "10"
    persistentvolumeclaims: "10"
    replicationcontrollers: "20"
    secrets: "10"
    services: "10"
    services.loadbalancers: "2"
```

### User Management

There are 2 different types of users you can create

- A normal user meant to access the user externally
  - User not managed through objects
- A service user, which is managed by objects in Kubernetes
  - This is the type of user used to authenticate within the cluster
  - From within a pod or from kubelet
  - Credentials are managed like secrets
- There are multiple authentication strategies for normal users
  - Client certificates
  - Bearer tokens
  - Authentication proxy
  - HTTP Basic Authentication
  - OpenID
  - Webhooks

- Service users use service account tokens
- They are stored as credentials using secrets
  - Those secrets are also stored in pods to allow communication between the services
- Service users are specific to a namespace
- Any API call that is not authenticated is considered to be an anonymous user
- Independently from the authentication mechanism, normal users have the following attributes:
  - A username
  - A UID
  - Groups
  - Extra fields

- After a normal user authenticates they will have access to everything.
- To limit access, you need to configure authorization
- There are multiple offerings to choose from:
  - Always Allow / Always Deny
  - ABAC (Attribute-Based Access Control)
- RBAC (Role-Based Access Control)
- Webhook (authorized by remote service)

- Authorization is still a work in progress
- The ABAC needs to be configured manually
- RBAC uses rbac.authorization.k8s.io API group
  - This allows admins to dynamically configure permissions through the API

### Networking

- The approach to networking is quite different than the default Docker setup
- Kubernetes assumes that pods should be able to communicate to other pods, regardless of which
node they are running
  - Every pod has its own IP address
  - Pods on different nodes need to be able to communicate to each other using those IP addresses
  - Implemented differently depending on your networking setup

- On AWS: kubenet networking
- Alternatives:
  - Container Networking Interface (CNI)
    - Software that provides libraries / plugins for network interfaces within containers
    - Popular solutions include Calico and Weave
  - An overlay network
    - Flannel is an easy and popular way

### Node Maintenance

- NodeController is responsible for managing the Node objects
  - It assigns an IP space to the node when a new node is launched
  - It keeps the node list up-to-date with the available machines
  - The node controller is also monitoring the health of the node
    - If a node is unhealthy it gets deleted
    - Pods running on the unhealthy node will get rescheduled

- When adding a new node, the kubelet will attempt to register itself
- This is called self-registration and is the default behavior
- It allows you to easily add more nodes to the cluster without making API changes yourself
- A new node object is automatically created with:
  - The metadata (IP or hostname)
  - Labels (cloud region / availability zone / instance size)
- A node also has a node condition (e.g. Ready, OutOfDisk)
- When you want to decommission a node, you want to do it gracefully
  - You drain the node before you shut it down or take it out of the cluster
- To drain a node you use the following command:

```
kubectl drain nodename --grace-period=600
```

If the node runs pods not managed by a controller use:

```
kubectl drain nodename --force
```

### High Availability

- If you're going to run your cluster in production, you're going to want to have all master
services in a high availability (HA) setup
- The setup looks like this:
  - Clustering etcd: run at least 3 etcd nodes
  - Replicated API servers with a LoadBalancer
  - Running multiple instances of the scheduler and the controllers
    - Only one is the leader and the rest are on stand-by
- A cluster like minikube does not HA, it is only one cluster
- If you are going to use a cluster on AWS, kops can do the heavy lifting for you

## Credit

- https://www.github.com/jleetutorial/
