# Docker Documentation

## Table of Contents
1. [Introduction to Containerization](#introduction-to-containerization)
2. [Containers from Scratch](#containers-from-scratch)
3. [Evolution of Content Serving](#evolution-of-content-serving)
4. [Docker Architecture](#docker-architecture)
5. [Dockerfile](#dockerfile)
6. [Docker Images](#docker-images)
7. [Docker Containers](#docker-containers)
8. [Docker Volumes and Networks](#docker-volumes-and-networks)
9. [Docker Commands](#docker-commands)

## 1. Introduction to Containerization

Containerization is a lightweight alternative to full machine virtualization that involves encapsulating an application in a container with its own operating environment. This approach allows for consistent, portable, and efficient application deployment across different computing environments.

Key benefits of containerization include:
- Consistency across development, testing, and production environments
- Improved resource utilization compared to traditional virtualization
- Faster application startup times
- Easier scaling and management of applications

## 2. Containers from Scratch

Understanding containers at a low level involves three key Linux kernel features:

### cgroups (Control Groups)
cgroups limit and isolate the resource usage (CPU, memory, disk I/O, network, etc.) of a collection of processes.

### Namespaces
Namespaces provide isolation for various system resources, making it appear to processes within a namespace that they have their own isolated instance of the global resource.

### chroot (Change Root)
chroot changes the apparent root directory for the current running process and its children, providing isolation at the file system level.

By combining these technologies, we can create lightweight, isolated environments that form the basis of containers.

`I created a script that demonstrates how to create a simple container using these technologies. You can find the script here: [./CFS/setup_container.sh](./CFS/setup_container.sh)`

## 3. Evolution of Content Serving

### Bare Metal or Physical Servers
Traditional approach using dedicated hardware for each application.

Limitations:
- Resource underutilization
- Difficult to scale
- Long provisioning times
- High maintenance costs

### Virtual Machines
Virtualization allows multiple virtual servers to run on a single physical machine.

Limitations:
- Overhead of running multiple operating systems
- Resource-intensive
- Slower start-up times compared to containers

### Containers
Containers package application code and dependencies together, sharing the host OS kernel.

Advantages:
- Lightweight and fast
- Efficient resource utilization
- Consistent environments across development and production

### Hybrid Approach: Virtual Machines and Containers
Combining VMs and containers can provide benefits of both worlds:
- Use VMs for strong isolation between tenants or applications
- Use containers for efficient resource utilization and rapid scaling within VMs

## 4. Docker Architecture

Docker uses a client-server architecture:

1. Docker Client: Command-line interface for interacting with Docker
2. Docker Host: Runs the Docker daemon (dockerd)
3. Docker Registry: Stores Docker images (e.g., Docker Hub)

Components:
- Docker daemon: Manages Docker objects (images, containers, networks, volumes)
- REST API: Specifies interfaces for interacting with the daemon
- Docker CLI: Uses the REST API to control or interact with the Docker daemon

## 5. Dockerfile

A Dockerfile is a text document containing instructions to build a Docker image. Key instructions include:

- `FROM`: Specifies the base image
- `RUN`: Executes commands in a new layer
- `COPY` and `ADD`: Copies files from host to the container
- `EXPOSE`: Informs Docker that the container listens on specified network ports
- `CMD`: Provides defaults for an executing container

Example Dockerfile:
```dockerfile
FROM node:14
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

## 6. Docker Images

Docker images are read-only templates used to create containers. They are built from the instructions in a Dockerfile.

Key concepts:
- Layers: Each instruction in a Dockerfile creates a new layer
- Image tags: Used for version control
- Image sharing: Images can be pushed to and pulled from registries

## 7. Docker Containers

Containers are runnable instances of Docker images. They can be started, stopped, moved, and deleted.

Key operations:
- Creating and starting containers
- Stopping and restarting containers
- Executing commands inside containers
- Inspecting container logs and status

## 8. Docker Volumes and Networks

### Docker Volumes
Volumes provide persistent storage for containers:
- Persist data even when containers are deleted
- Can be shared among multiple containers
- Can be managed using Docker CLI commands

### Docker Networks
Docker networking allows containers to communicate with each other and the outside world:
- Bridge networks for communication between containers on the same Docker host
- Overlay networks for communication between containers across multiple Docker hosts
- Host and Macvlan networks for specialized use cases

Each of these topics can be expanded with more detailed information, examples, and best practices as needed.

## 9. Docker Commands

### Use an existing Image to run a container (Docker Hub)
`docker run -d -p 80:80 --name webserver nginx`
- `-d` runs the container in detached mode
- `-p 80:80` maps port 80 on the host to port 80 on the container
- `--name webserver` assigns the name "webserver" to the container
- `nginx` specifies the image to use

### Use a Dockerfile to build an Image and run a Container
1. Create a Dockerfile with the following content:
```dockerfile
FROM nginx
COPY index.html /usr/share/nginx/html
```
2. Build the Docker image:
`docker build -t my-nginx .`
- `-t my-nginx` tags the image with the name "my-nginx"
- `.` specifies the build context (current directory)

3. Run a container using the new image:
`docker run -d -p 80:80 --name my-nginx-container my-nginx`


### Attaching to an already-running Container
By default, if you run a Container without `-d`, you run in "attached mode".

If you started a container in detached mode (i.e. with `-d`), you can still attach to it afterwards without restarting the Container with the following command:

- `docker attach CONTAINER`: attaches you to a running Container with an ID or name of CONTAINER.

### Entering interactive mode
You can enter an interactive shell inside a running container using the following command:
- `docker run -it IMAGE /bin/bash`
- `docker start -ia CONTAINER`
    - `-i` keeps STDIN open even if not attached
    - `-t` allocates a pseudo-TTY
    - `-a` attaches to STDIN, STDOUT, and STDERR

### Stopping and Removing Containers
To stop a running container, use the `docker stop` command:
- `docker stop CONTAINER1 CONTAINER2`
To remove a container, use the `docker rm` command:
- `docker rm CONTAINER1 CONTAINER2`
To stop and remove a container in one command, use the `-f` flag:
- `docker rm -f CONTAINER`

### Removing Images
To remove a Docker image, use the `docker rmi` command:
- `docker rmi IMAGE1 IMAGE2`

### Inspecting Docker Objects
To inspect a Docker object (image, container, volume, network), use the `docker inspect` command:
- `docker inspect OBJECT_ID`

### Copying Files to/from Containers
To copy files to/from a container, use the `docker cp` command:
- `docker cp FILE CONTAINER:PATH`: Copy a file from the host to the container
- `docker cp CONTAINER:PATH FILE`: Copy a file from the container to the host

### Naming & Tagging Images and Containers
- When running a container, you can specify a name using the `--name` flag:
- When building an image, you can specify a name and tag using the `-t` flag:
`docker build -t my-image:latest .`
- An image tag is seprated into two parts by a colon, the first part is the image name and the second part is the tag.
- The tag is used to version the image, e.g., `latest`, `v1.0`, `dev`, etc.

### Pushing and Pulling Images
Login to Docker Hub:
- `docker login`
Push an image to Docker Hub:
- `docker push USERNAME/IMAGE_NAME:TAG`
Pull an image from Docker Hub:
- `docker pull USERNAME/IMAGE_NAME:TAG`

### Cleaning Up Docker Resources
To clean up unused Docker resources (containers, images, volumes, networks), use the `docker system prune` command:
- `docker system prune`: Remove all unused resources
- `docker system prune -a`: Remove all unused resources, including images
- `docker system prune -fa`: Remove all unused resources without confirmation