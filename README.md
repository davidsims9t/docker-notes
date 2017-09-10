# Docker Notes

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

## Credit

- https://www.github.com/jleetutorial/
