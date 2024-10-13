#!/bin/bash

# Update the system to get the latest patches
echo "Updating the system..."
sudo apt update -y && sudo apt upgrade -y

# Install required utilities: zip, unzip
echo "Installing utilities zip and unzip..."
sudo apt install -y zip unzip

# Install NGINX web server
echo "Installing NGINX web server..."
sudo apt install -y nginx

# Remove sample test pages from Nginx web server (default HTML files)
echo "Removing default Nginx pages from /var/www/html..."
sudo rm -rf /var/www/html/*

# Clone Login App from the repository
echo "Cloning Login App from GitHub repository..."
sudo git clone https://github.com/ravi2krishna/login-2429.git /var/www/html

# Set appropriate permissions for the web directory
echo "Setting permissions for the Nginx document root..."
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# Restart Nginx service to load the new content
echo "Restarting NGINX web server..."
sudo systemctl restart nginx

# Check if Nginx is running
if systemctl status nginx | grep "active (running)" > /dev/null
then
    echo "NGINX is running."
else
    echo "NGINX failed to start."
    exit 1
fi

# Verify if the server is loading the login app
echo "Checking if the Login App is loading..."
APP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)

if [ "$APP_STATUS" -eq 200 ]; then
    echo "Login App is successfully loaded on the server."
else
    echo "Failed to load the Login App on the server."
    exit 1
fi
