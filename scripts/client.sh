#!/bin/bash

sudo apt-get update
sudo apt-get install apache2 -y
sudo apt-get install -y nginx
sudo apt-get install -y memcache

sudo service nginx start

sudo systemctl start memcached
sudo systemctl enable memcached


cat << 'EOT' > /etc/nginx/conf.d/cache.conf
proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m max_size=100m inactive=60m use_temp_path=off;

server {
    listen 80;

    location / {
        proxy_pass http://localhost:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_cache my_cache;
        proxy_cache_valid 200 1m;
        proxy_cache_use_stale error timeout updating invalid_header http_500 http_502 http_503 http_504;
        proxy_cache_key "$scheme$request_method$host$request_uri";
        add_header X-Cache-Status $upstream_cache_status;

    }

    location /memcached {
        internal;
        set $memcached_key $uri;
        memcached_pass 127.0.0.1:11211;
        error_page 404 = @fallback;
    }

    location @fallback {
        proxy_pass http://reverse_proxy_server_ip:80;  # Replace with your reverse proxy server's IP address
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_cache my_cache;
        proxy_cache_valid 200 1m;
        proxy_cache_use_stale error timeout updating invalid_header http_500 http_502 http_503 http_504;
        proxy_cache_key "$scheme$request_method$host$request_uri";
        add_header X-Cache-Status $upstream_cache_status;
    }
}
EOT



sudo service nginx restart

# Start a simple web server on port 80 for testing

cat << 'EOT' > /var/www/html/index.html
    <html>
    <head>
      <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f0f0f0;
    }
    .container {
      max-width: 800px;
      margin: 20px auto;
      padding: 20px;
      background-color: #fff;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    h1 {
      text-align: center;
    }
    .button {
      padding: 10px 20px;
      margin: 10px;
      font-size: 16px;
      cursor: pointer;
      background-color: #4CAF50;
      color: white;
      border: none;
      border-radius: 4px;
      transition: background-color 0.3s;
    }
    .button:hover {
      background-color: #45a049;
    }
    .image-container {
      margin-top: 20px;
      text-align: center;
    }
    #imageDisplay {
      max-width: 100%;
      height: auto;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    </style>
      <script>
        function showImage(imageUrl) {
          document.getElementById('imageDisplay').src = imageUrl;
        }
      </script>
        <title>Client VM Cache Test</title>
    </head>
    <body>
      <h1>Hello from client ${count.index}</h1>
      <p>This is a test page served by the client VM.</p>
    </body>
    </html>
EOT

sudo service apache2 start

sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
sudo systemctl restart nginx