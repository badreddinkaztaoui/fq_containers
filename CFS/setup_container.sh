#!/bin/bash

# Make sure the container is running as root
if [ "$(id -u)" != "0" ]; then
    echo "This container must be run as root" 1>&2
    exit 1
fi

echo -e "\033[1;33mSetting up the container...\033[0m"
CONTAINER_DIR="/tmp/container"
mkdir -p $CONTAINER_DIR

# Download a minimal rootfs
VOID_VERSION="20240314"
VOID_ARCH="x86_64-musl"
ROOTFS="void-${VOID_ARCH}-ROOTFS-${VOID_VERSION}.tar.xz"

echo -e "\033[1;33mDownloading the Void Linux rootfs...\033[0m"
wget --no-check-certificate https://repo-default.voidlinux.org/live/current/${ROOTFS} >/dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Failed to download the Void Linux rootfs. Please check the URL and your internet connection."
    exit 1
fi

echo -e "\033[1;33mExtracting the Void Linux rootfs...\033[0m"
tar -C $CONTAINER_DIR -xvf $ROOTFS >/dev/null 2>&1
rm $ROOTFS

echo -e "\033[1;32mRootfs setup completed.\033[0m"

echo -e "\033[1;33mCreating cgroups ...\033[0m"

CGROUP_NAME="cfs"

create_cgroup() {
    local subsys=$1
    local cgroup_path="/sys/fs/cgroup/${subsys}/${CGROUP_NAME}"
    if [ ! -d $cgroup_path ]; then
        mkdir -p $cgroup_path
    fi
    echo -e "\033[1;34mCreated cgroup: ${subsys}/${CGROUP_NAME}\033[0m"
}

create_cgroup "cpu"
create_cgroup "memory"
create_cgroup "pids"

# Set the cgroup limits
echo 50000 > /sys/fs/cgroup/cpu/$CGROUP_NAME/cpu.cfs_quota_us
echo 100000 > /sys/fs/cgroup/cpu/$CGROUP_NAME/cpu.cfs_period_us
echo 512M > /sys/fs/cgroup/memory/$CGROUP_NAME/memory.limit_in_bytes
echo 100 > /sys/fs/cgroup/pids/$CGROUP_NAME/pids.max

echo -e "\033[1;32mCgroups setup completed.\033[0m"

# Run the container [...] 