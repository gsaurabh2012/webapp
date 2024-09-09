
#!/bin/bash

echo "SYSTEM UPDATE"
sudo apt update -y 
sleep 5

echo "INSTALL UTILITIES"
sudo apt install -y zip unzip
sleep 5

echo "Install NGINX SERVER"
sudo apt install -y nginx
sleep 5

echo "Remove the sample file"
sudo rm -rf /var/www/html
sleep 5

echo "clone app"
sudo git clone https://github.com/gsaurabh2012/webapp.git /var/www/html
sleep 5

echo "browser app using ip addr"
