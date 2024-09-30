#!/bin/bash

# Make sure the container is running as root
if [ "$(id -u)" != "0" ]; then
    echo "This container must be run as root" 1>&2
    exit 1
fi

CONTAINER_DIR="/tmp/container"
mkdir -p $CONTAINER_DIR

# Download a minimal rootfs
