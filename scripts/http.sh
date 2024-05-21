#!/bin/bash

sudo apt-get update
sudo apt-get install apache2 -y
sudo service apache2 restart 
# sudo apt-get install -y nginx-light jq

echo '<!doctype html><html><body><h1>web-html</h1></body></html>' | sudo tee /var/www/html/index.html