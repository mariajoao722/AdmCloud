#!/bin/bash

# Registrar início do script
echo "Iniciando script de instalação" | sudo tee -a /var/log/startup-script.log

# Atualizar pacotes
sudo apt-get update | sudo tee -a /var/log/startup-script.log

# Instalar Apache
sudo apt-get install -y apache2 | sudo tee -a /var/log/startup-script.log

# Instalar Nginx
sudo apt-get install -y nginx | sudo tee -a /var/log/startup-script.log

sudo service nginx start | sudo tee -a /var/log/startup-script.log


# Verificar instalação do Apache
if apache2 -v > /dev/null 2>&1; then
    echo "Apache instalado com sucesso." | sudo tee -a /var/log/startup-script.log
else
    echo "Falha na instalação do Apache." | sudo tee -a /var/log/startup-script.log
fi


# Verificar instalação do Nginx
if nginx -v > /dev/null 2>&1; then
    echo "Nginx instalado com sucesso." | sudo tee -a /var/log/startup-script.log
else
    echo "Falha na instalação do Nginx." | sudo tee -a /var/log/startup-script.log
fi

#instalar Memcache
sudo apt-get install -y memcache |  sudo tee -a /var/log/startup-script.log
sudo systemctl start memcached |  sudo tee -a /var/log/startup-script.log
sudo systemctl enable memcached |  sudo tee -a /var/log/startup-script.log

#sudo apt-get install -y python3-pip | sudo tee -a /var/log/startup-script.log

#sudo pip install Flask | sudo tee -a /var/log/startup-script.log

#sudo pip install google-cloud-storage | sudo tee -a /var/log/startup-script.log



CONFIG_FILE_APACHE2="/etc/apache2/sites-available/000-default.conf"

# Substituir o conteúdo do arquivo de configuração com a nova porta
sudo tee $CONFIG_FILE_APACHE2 > /dev/null << 'EOT'
<VirtualHost *:8080>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOT


PORTS_CONFIG_FILE="/etc/apache2/ports.conf"

sudo sed -i 's/Listen 80/Listen 8080/g' "$PORTS_CONFIG_FILE"


sudo systemctl restart apache2



cat << 'EOT' > /etc/nginx/sites-available/default
server {
    listen 8000;

    location / {
            proxy_pass http://natIp:8080;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
    } 
}
EOT

NAT_IP=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)

#CHANGE_IP = "/etc/nginx/sites-available/default"

#sudo sed -i 's/natIp/${NAT_IP}/g' "$CHANGE_IP"

sudo bash -c "sed -i 's/natIp/$NAT_IP/g' /etc/nginx/sites-available/default"


# server pode ser que seja conectado ao nosso ip e nao ao local host, vamos ver
cat << 'EOT' > /etc/nginx/sites-available/cache.conf
proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=custom_cache:10m max_size=100m inactive=60m;


upstream origin_server {
    server 127.0.0.1:8000;
    
}

server {
    listen 8001;
    server_name _;

    location / {
        include proxy_params;
        proxy_pass http://origin_server;

        proxy_cache custom_cache;
        proxy_cache_valid any 10m;
        add_header X-Proxy-Cache $upstream_cache_status;
    }
}
EOT
sudo bash -c "sed -i 's/natIp/$NAT_IP/g' /etc/nginx/sites-available/cache.conf"

ln -s /etc/nginx/sites-available/cache.conf /etc/nginx/sites-enabled/

sudo service nginx restart | sudo tee -a /var/log/startup-script.log

sudo mkdir -p /var/www/html/templates

cat << 'EOT' > /var/www/html/templates/index.html
    <html lang="pt-BR">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Site do Cliente</title>
        <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
        }

        header {
            background-color: #333;
            color: #fff;
            padding: 1em 0;
            text-align: center;
            position: relative;
        }

        nav ul {
            list-style: none;
            padding: 0;
        }

        nav ul li {
            display: inline;
            margin: 0 1em;
        }

        nav ul li a {
            color: #fff;
            text-decoration: none;
        }

        #login {
            position: absolute;
            top: 1em;
            right: 1em;
            background: #fff;
            padding: 0.5em;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            color: #333;
        }

        #login label {
            margin: 0;
            display: block;
        }

        #login form {
            display: inline-block;
        }

        #login button {
            padding: 0.5em 1em;
            border: none;
            border-radius: 3px;
            background: #333;
            color: #fff;
            font-size: 1em;
            cursor: pointer;
        }

        main {
            padding: 2em;
        }

        section {
            background: #fff;
            padding: 1em;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            margin-bottom: 2em;
        }

        section h2 {
            color: #333;
        }

        ul {
            list-style: none;
            padding: 0;
        }

        ul li {
            background: #fff;
            margin: 0.5em 0;
            padding: 1em;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        ul li a {
            color: #333;
            text-decoration: none;
        }
    </style>
    </head>
    <body>
        <header>
        <h1>Bem-vindo ao Site do Cliente</h1>

        <div id="login">
            <form id="admin-login" action="{{ url_for('login') }}">
                <button type="submit">Login para Admins</button>
            </form>
        </div>
        </header>
        <main>
            <section>
                <h2>Decentralized Virtual CDN</h2>
                <p>No âmbito da unidade curricular de Administração de Sistemas Cloud foi proposta a realização de um projeto visando criar um serviço descentralizado, usando as ferramentas da Google Cloud, que possibilitasse o fornecimento de conteúdo a clientes espalhados pelo mundo. O propósito do uso de uma CDN e aproximar os servidores, que dispõem o serviço dos clientes de maneira  a reduzir a latência entre eles</p>
            </section>

            <ul>
                {% for blob in blobs %}
                <li>
                    <a href="{{ blob.url }}" target="_blank">{{ blob.name }}</a>
                </li>
                {% endfor %}
            </ul>
        </main>
    </body>
    </html>
EOT

cat << 'EOT' > /var/www/html/templates/login.html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Site do Cliente</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        h1 {
            color: #333;
            margin-bottom: 1em;
            font-size: 2.5em; /* Aumentando o tamanho da fonte */
        }

        .login-container {
            background: #fff;
            padding: 2em;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            margin-bottom: 0.5em;
            color: #333;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 0.5em;
            margin-bottom: 1em;
            border: 1px solid #ccc;
            border-radius: 3px;
        }

        input[type="submit"] {
            width: 100%;
            padding: 0.5em;
            border: none;
            border-radius: 3px;
            background: #333;
            color: #fff;
            font-size: 1em;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <h1>Login</h1>
    <div class="login-container">
        <form action="{{ url_for('login') }}" method="post">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            <input type="submit" value="Login">
        </form>
    </div>
</body>
</html>

EOT

cat << 'EOT' > /var/www/html/templates/auth.html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Website</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
        }

        header {
            background-color: #333;
            color: #fff;
            padding: 1em 0;
            text-align: center;
            position: relative;
        }

        header h1 {
            margin: 0;
        }

        .logout {
            position: absolute;
            top: 1em;
            right: 1em;
            background: #fff;
            padding: 0.5em;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        .logout form {
            margin: 0;
        }

        .logout button {
            padding: 0.5em 1em;
            border: none;
            border-radius: 3px;
            background: #333;
            color: #fff;
            font-size: 1em;
            cursor: pointer;
        }

        main {
            padding: 2em;
        }

        ul {
            list-style: none;
            padding: 0;
        }

        ul li {
            background: #fff;
            margin: 0.5em 0;
            padding: 1em;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        ul li a {
            color: #333;
            text-decoration: none;
        }

        form {
            display: inline-block;
            margin: 0;
        }

        form button, input[type="submit"] {
            padding: 0.5em 1em;
            border: none;
            border-radius: 3px;
            background: #333;
            color: #fff;
            font-size: 1em;
            cursor: pointer;
        }

        label {
            display: block;
            margin-bottom: 0.5em;
            color: #333;
        }

        input[type="file"] {
            display: block;
            margin-bottom: 1em;
        }
    </style>
</head>
<body>
    <header>
        <h1>Bem-vindo ao Painel do Admistrador </h1>
        <div class="logout">
            <form action="{{ url_for('index') }}">
                <button type="submit">Logout</button>
            </form>
        </div>
    </header>

    <main>
        <ul>
            {% for blob in blobs %}
            <li>
                <a href="{{ blob.url }}" target="_blank">{{ blob.name }}</a>
                <form action="{{ url_for('delete', file_name=blob.name) }}" method="post">
                    <button type="submit">Delete</button>
                </form>
            </li>
            {% endfor %}
        </ul>

        <form action="{{ url_for('upload') }}" method="post" enctype="multipart/form-data">
            <label for="file">Filename:</label>
            <input type="file" id="file" name="file" required>
            <button type="submit">Upload</button>
        </form>
    </main>
</body>
</html>

EOT

cat << 'EOT' > /var/www/html/templates/auth_error.html

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Site do Cliente</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        h1 {
            color: #333;
            margin-bottom: 1em;
            font-size: 2.5em; /* Aumentando o tamanho da fonte */
        }

        .login-container {
            background: #fff;
            padding: 2em;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
        }

        .error-message {
            color: red;
            margin-bottom: 1em;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            margin-bottom: 0.5em;
            color: #333;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 0.5em;
            margin-bottom: 1em;
            border: 1px solid #ccc;
            border-radius: 3px;
        }

        input[type="submit"] {
            width: 100%;
            padding: 0.5em;
            border: none;
            border-radius: 3px;
            background: #333;
            color: #fff;
            font-size: 1em;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <h1>Login</h1>
    <div class="login-container">
        <p class="error-message">Invalid username or password</p>
        <form action="{{ url_for('login') }}" method="post">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            <input type="submit" value="Login">
        </form>
    </div>
</body>
</html>

EOT

cat << 'EOT' > /var/www/html/app.py
from flask import Flask, render_template, request, redirect, url_for, flash
from google.cloud import storage

app = Flask(__name__)
app.secret_key = 'supersecretkey'
bucket_name = 'bucket-unique-bucket'

#Default
@app.route('/')
def index():
    client = storage.Client.from_service_account_json('/var/www/html/keys.json')
    buckets = client.bucket(bucket_name)
    blobs = buckets.list_blobs()

    blobs_data=[]

    for blob in blobs:
        blob.make_public()
        url = blob.public_url
        blobs_data.append({'name': blob.name, 'url': url})

    return render_template('index.html', blobs=blobs_data)


#Login
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        if request.form['username'] == 'admin' and request.form['password'] == 'admin':
            return redirect(url_for('auth'))
        else:
            return redirect(url_for('auth_error'))
    return render_template('login.html')

#Erro
@app.route('/auth_error')
def auth_error():
    return render_template('auth_error.html')

#Auth
@app.route('/auth')
def auth():
    client = storage.Client.from_service_account_json('/var/www/html/keys.json')
    buckets = client.bucket(bucket_name)
    blobs = buckets.list_blobs()

    blobs_data=[]

    for blob in blobs:
        blob.make_public()
        url = blob.public_url
        blobs_data.append({'name': blob.name, 'url': url})

    return render_template('auth.html', blobs=blobs_data)

#Upload
@app.route('/upload', methods=['POST'])
def upload():
        f = request.files['file']
        if f:
            client = storage.Client.from_service_account_json('/var/www/html/keys.json')
            bucket = client.bucket(bucket_name)

            blob = bucket.blob(f.filename)
            blob.upload_from_string(f.read(), content_type=f.content_type)
            flash('File uploaded successfully')
        return redirect(url_for('auth'))


#Delete
@app.route('/delete/static/<file_name>', methods=['POST'])
def delete(file_name):
    client = storage.Client.from_service_account_json('/var/www/html/keys.json')
    bucket = client.bucket(bucket_name)

    blob = bucket.blob(file_name)
    blob.delete()

    return redirect(url_for('auth'))


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=443, debug=True)
EOT

cat << 'EOT' > /var/www/html/keys.json
{
  
}

EOT

sudo chmod +x home/mjmarquespais/var/www/html/app.py

sudo export GOOGLE_APPLICATION_CREDENTIALS=/home/mjmarquespais/var/www/html/keys.json

sudo service apache2 start | sudo tee -a /var/log/startup-script.log

cat << 'EOT' > home/mjmarquespais/flask.service
[Unit]
Description=Flask App
After=network.target

[Service]
Type=simple
Restart=always
ExecStart=/usr/bin/sudo /usr/bin/python3 /home/mjmarquespais/var/www/html/app.py

[Install]
WantedBy=multi-user.target
EOT


 cat << 'EOT' > home/mjmarquespais/script.sh
    #!/bin/bash
    sudo cp /home/mjmarquespais/flask.service /etc/systemd/system/flask.service 

    sudo systemctl daemon-reload 
    sudo systemctl enable flask
    sudo systemctl start flask
EOT

 cat << 'EOT' > home/mjmarquespais/scriptpip.sh
    #!/bin/bash
    sudo apt-get install -y python3-pip 

    sudo pip install Flask 

    sudo pip install google-cloud-storage 
EOT

sudo chmod +x home/mjmarquespais/script.sh
sudo chmod +x home/mjmarquespais/scriptpip.sh
