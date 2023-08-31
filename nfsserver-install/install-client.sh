#!/bin/bash
# Install and configure NFS Client

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root or with sudo."
    exit 1
fi

if [ -z "$1" ] || [ -z "$2" ] | [ -z "$3" ]; then
    echo "Usage: $0 <NFS_directory> <NFS_ip_address> <NFS_server_path>"
    exit 1
fi

# The path received from arguments
path="$1"
server_ip="$2"
server_path="$3"

echo "Log in to the client system and update the package"
sudo apt update -y

echo "Install the nfs-common package"
sudo apt install -y nfs-common

echo "Create folder for mount folder sharing"
sudo mkdir -p $path

echo "Edit file /etc/fstab"
echo "$server_ip:$server_path	$path	nfs	nouser,rw,auto 0 0" >> /etc/fstab

echo "Mount the remote NFS share directory to the client directory"
sudo mount $path

sudo ls -l $path
