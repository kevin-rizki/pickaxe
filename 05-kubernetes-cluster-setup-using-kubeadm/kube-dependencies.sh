#!/bin/bash
# This script perform basic installation and setup for kubernetes cluster
# Run on all nodes for target cluster

KUBERNETES_VERSION=1.25.4-00

# Validate if the script being run using administrative privilege or not
if [ $(id -u) -ne 0 ]; then
    echo "This script must be run with administrative privileges"
    exit 1
fi

# Add Kubernetes repository for Ubuntu 20.04
apt -y install curl apt-transport-https git wget
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update package list
apt update -y

# Check kubelet, kubeadm, and kubectl before installing
apt-cache madison kubelet
apt-cache madison kubeadm
apt-cache madison kubectl

# Install the Kubernetes with specify version
apt install -y kubelet=${KUBERNETES_VERSION} kubeadm=${KUBERNETES_VERSION} kubectl=${KUBERNETES_VERSION}

# Confirm installation by checking the version of kubectl
kubectl version --client && kubeadm version

# Disable swap
swapon --show
swapoff -a
rm /swap.img
sed -i '/\/swap\.img/d' /etc/fstab
swapon --show


# Enable the kernel modules
modprobe overlay
modprobe br_netfilter

# Configure sysctl 
echo "net.bridge.bridge-nf-call-ip6tables = 1" >> /etc/sysctl.d/kubernetes.conf
echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.d/kubernetes.conf
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/kubernetes.conf

sysctl --system

# Install Docker Container Runtime
apt update
apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \ $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Create the required directories
mkdir -p /etc/systemd/system/docker.service.d
mkdir /etc/docker
echo "{" > /etc/docker/daemon.json
echo "  "exec-opts": ["native.cgroupdriver=systemd"]," >> /etc/docker/daemon.json
echo "  "log-driver": "json-file"," >> /etc/docker/daemon.json
echo "  "log-opts": {" >> /etc/docker/daemon.json
echo "  "exec-opts": ["native.cgroupdriver=systemd"]," >> /etc/docker/daemon.json
echo "      "max-size": "100m"" >> /etc/docker/daemon.json
echo "  }," >> /etc/docker/daemon.json
echo "  "storage-driver": "overlay2"" >> /etc/docker/daemon.json
echo "}" >> /etc/docker/daemon.json

# Enable the Docker service
systemctl daemon-reload
systemctl restart docker
systemctl enable docker

# Make sure the Docker service is running
systemctl status docker

# Install Mirantis cri-dockerd
VER=$(curl -s https://api.github.com/repos/Mirantis/cri-dockerd/releases/latest|grep tag_name | cut -d '"' -f 4|sed 's/v//g')
echo $VER
wget https://github.com/Mirantis/cri-dockerd/releases/download/v${VER}/cri-dockerd-${VER}.amd64.tgz
tar xvf cri-dockerd-${VER}.amd64.tgz
mv cri-dockerd/cri-dockerd /usr/local/bin/
cri-dockerd --version
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.service
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.socket
mv cri-docker.socket cri-docker.service /etc/systemd/system/
sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service

# Enable the cri-dockerd service
systemctl daemon-reload
systemctl enable cri-docker.service
systemctl enable --now cri-docker.socket

# Make sure the cri-dockerd is running
systemctl status cri-docker