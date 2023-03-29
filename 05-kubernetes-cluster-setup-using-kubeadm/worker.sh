#!/bin/bash
# Add worker nodes to the Cluster
# Run on worker node

# Set master IP address
MASTER_IP=192.168.7.149

# Validate if the script being run using administrative privilege or not
if [ $(id -u) -ne 0 ]; then
    echo "This script must be run with administrative privileges"
    exit 1
fi

# Add a record to /etc/hosts
echo "${MASTER_IP} master" >> /etc/hosts

# Join node to the cluster
kubeadm join 192.168.7.149:6443 –token yfw348.o99to157wyyl0v0z  –discovery-token-ca-cert-hash sha256:e3c803a6d200ac3bb8bc3955676b05f435f6f00ce20d1f30a43efbee3db7be4f sudo 

# Check if the nodes are in the cluster
kubectl get nodes