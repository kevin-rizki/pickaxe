#!/bin/bash

# Download and install Apache Maven
wget https://dlcdn.apache.org/maven/maven-3/3.9.0/binaries/apache-maven-3.9.0-bin.tar.gz -o /tmp/apache-maven.tar.gz
sudo tar xf /tmp/apache-maven.tar.gz -C /opt
sudo ln -s /opt/apache-maven-3.8.4 /opt/maven

# Set environment variables
echo "export M2_HOME=/opt/maven" >> ~/.bashrc
echo "export MAVEN_HOME=/opt/maven" >> ~/.bashrc
echo "export PATH=\${M2_HOME}/bin:\${PATH}" >> ~/.bashrc

# Load environment variables
source ~/.bashrc

# Verify installation
mvn -version