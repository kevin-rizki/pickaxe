#!/bin/bash

# Update package repositories
sudo apt update

# Install OpenSSH server
sudo apt install -y openssh-server

# Create ssh group if it does not exist
if ! getent group ssh > /dev/null; then
  sudo groupadd ssh
fi

# Create backup of the sshd_config file
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Modify the sshd_config file to configure OpenSSH
sudo sed -i 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

# Create new systemd service file for OpenSSH
cat << EOF | sudo tee /etc/systemd/system/ssh.service
[Unit]
Description=OpenSSH server

[Service]
ExecStart=/usr/sbin/sshd -D
ExecReload=/bin/kill -HUP \$MAINPID
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd configuration
sudo systemctl daemon-reload

# Enable ssh service to start automatically on boot
sudo systemctl enable ssh.service

# Start ssh service
sudo systemctl start ssh.service

# Display status of ssh service
sudo systemctl status ssh.service