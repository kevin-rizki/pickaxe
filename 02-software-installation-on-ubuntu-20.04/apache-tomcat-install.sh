#!/bin/bash

# Install prerequisites
sudo apt update
sudo apt install -y default-jdk

# Download and extract Tomcat 9
wget -q https://downloads.apache.org/tomcat/tomcat-9/v9.0.55/bin/apache-tomcat-9.0.55.tar.gz -O /tmp/tomcat.tar.gz
sudo tar xf /tmp/tomcat.tar.gz -C /opt
sudo ln -s /opt/apache-tomcat-9.0.55 /opt/tomcat

# Set environment variables
echo "export CATALINA_HOME=/opt/tomcat" >> ~/.bashrc
echo "export PATH=\${CATALINA_HOME}/bin:\${PATH}" >> ~/.bashrc

# Load environment variables
source ~/.bashrc

# Start Tomcat
${CATALINA_HOME}/bin/startup.sh

# Verify installation
curl http://localhost:8080/