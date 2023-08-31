#!/bin/bash
# This script installs and configures an NFS server on the directory provided as a parameter

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root or with sudo."
    exit 1
fi

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <NFS_directory> <accepted_subnet>"
    exit 1
fi

# The path received from arguments
path="$1"
subnet="$2"

# Installing NFS Server
echo "[Update the package list]"
sudo apt update -y

echo "[Install the NFS kernel server package]"
sudo apt install -y nfs-kernel-server

echo "[Verify if the nfs-server service is running]"
sudo systemctl status nfs-server

# Create shared NFS directory
echo "Creating folder $path"
sudo mkdir -p "$path"

echo "Modifying the directory owner and permissions for full control"
sudo chown -R nobody:nogroup "$path"
sudo chmod -R 777 "$path"

echo "Allowing all users from the specified network to access the shared folder"
echo "$path   $subnet(rw,sync,no_subtree_check)" >> /etc/exports

echo "Exporting the directory and making it available"
sudo exportfs -a

echo "Configuring the firewall rule for NFS Server"
sudo ufw allow from "$subnet" to any port nfs
