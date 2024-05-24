#!/bin/bash

sudo apt-get update
sudo apt-get install apache2 -y
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
    </head>
    <body>
        <div class="container">
            <h1>Image Gallery from Google Cloud Storage</h1>
            <div class="image-buttons">
            <button class="button" onclick="showImage('https://storage.googleapis.com/bucket-unique-bucket/static/1.jpeg')">Image 1</button>
            <button class="button" onclick="showImage('https://storage.googleapis.com/bucket-unique-bucket/static/2.jpeg')">Image 2</button>
            <button class="button" onclick="showImage('https://storage.googleapis.com/bucket-unique-bucket/static/3.jpeg')">Image 3</button>
            <button class="button" onclick="showImage('https://storage.googleapis.com/bucket-unique-bucket/static/4.jpeg')">Image 4</button>
            <button class="button" onclick="showImage('https://storage.googleapis.com/bucket-unique-bucket/static/5.jpeg')">Image 5</button>
            <button class="button" onclick="showImage('https://storage.googleapis.com/bucket-unique-bucket/static/6.jpeg')">Image 6</button>
        </div>
        <div class="image-container">
            <img id="imageDisplay" src="" alt="Selected Image">
        </div>
    </div>
    </body>
    </html>
EOT

sudo service apache2 start
