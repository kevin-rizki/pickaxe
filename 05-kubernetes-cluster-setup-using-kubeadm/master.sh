#!/bin/bash
# Bash script to initialize Master node

# Validate if the script being run using administrative privilege or not
if [ $(id -u) -ne 0 ]; then
    echo "This script must be run with administrative privileges"
    exit 1
fi

# Log on master node, and make sure that br_netfilter module is loaded.
lsmod | grep br_netfilter

# Enable kubelet service
systemctl enable kubelet

# Pull container images
kubeadm config images pull –cri-socket unix:///run/cri-dockerd.sock

# Initialize Kubernetes control-plane by  ootstrapping a cluster.
# Set the pod-network-cidr to 172.16.0.0/16.
kubeadm init –pod-network-cidr=172.16.0.0/16 –cri-socket unix:///run/cri-dockerd.sock

# Configure kubectl using commands in the output
mkdir -p $HOME/.kube
cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Check the Kubernetes cluster status
kubectl cluster-info

# Install network plugin using Calico
wget https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/tigera-operator.yaml  

wget https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/custom-resources.yaml  

# Open custom-resources.yaml and edit the IP Pool CIDR to 172.16.0.0/16.
# Define the new CIDR
new_cidr="172.16.0.0/16"

# Use sed to replace the existing CIDR with the new CIDR in the file
sed -i "s/^[[:space:]]*cidr[[:space:]]*:[[:space:]]*.*/  cidr: ${new_cidr}/" custom-resources.yaml

# Output the new contents of the file
cat custom-resources.yaml

# Create kubernetes resources using the yaml files
kubectl create -f tigera-operator.yaml 
kubectl create -f custom-resources.yaml

# Confirm that all the pods are running
watch kubectl get pods --all-namespaces
