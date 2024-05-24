#!/bin/bash

sudo apt-get update
sudo apt-get install apache2 -y
# sudo service apache2 restart 
# sudo service apache2 start

# echo '<!doctype html><html><body><h1>web-html</h1></body></html>' | sudo tee /var/www/html/index.html

sudo apt-get install -y nginx
sudo service nginx start


cat << 'EOT' > /etc/nginx/sites-available/default
server {
    listen 80;

    location / {
            proxy_pass http://localhost:80;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOT

sudo service nginx restart

# Start a simple web server on port 80 for testing
#echo "<html><body><h1>Backend Server</h1></body></html>" > /var/www/html/index.html

cat << 'EOT' > /var/www/html/index.html
    <html>
    <body>
    <h1>Image from Google Cloud Storage</h1>
    <img src="https://storage.googleapis.com/bucket-unique-bucket/static/1.jpeg" alt="GCS Image">
    </body>
    </html>
EOT

sudo service apache2 start
