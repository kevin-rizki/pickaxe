#!/bin/bash

# Update the package list
sudo apt update

# Install Java Development Kit (JDK)
sudo apt install -y openjdk-11-jdk

# Add the Jenkins repository key to the system
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

# Add the Jenkins repository to the system
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Update the package list
sudo apt update

# Install Jenkins and its dependencies
sudo apt install -y jenkins

# Start the Jenkins service
sudo systemctl start jenkins

# Enable the Jenkins service to start on boot
sudo systemctl enable jenkins

# Print the initial Jenkins admin password to the console
sudo cat /var/lib/jenkins/secrets/initialAdminPassword