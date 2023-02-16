#!/bin/bash

# Add PostgreSQL repository
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update package list
sudo apt update

# Install PostgreSQL 13 and additional packages
sudo apt install -y postgresql-13 postgresql-contrib

# Enable and start the PostgreSQL service
sudo systemctl enable postgresql
sudo systemctl start postgresql

# Configure PostgreSQL to listen on all interfaces
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/13/main/postgresql.conf

# Add firewall rules to allow incoming connections to PostgreSQL
sudo ufw allow from any to any port 5432 proto tcp

# Set a password for the PostgreSQL user "postgres"
sudo -u postgres psql -c "ALTER USER postgres PASSWORD '<your_password_here>'"

echo "PostgreSQL 13 has been installed and configured!"