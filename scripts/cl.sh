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
    listen 80;

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


sudo service nginx restart | sudo tee -a /var/log/startup-script.log


cat << 'EOT' > /var/www/html/index.html
    <html>
    <head>
        <title>Website</title>
    </head>
    <body>
    <div id="content">
        <h1>Cliente Website</h1>
        <ul>
            {% for blob in blobs %}
            <li>
                <a href="{{ blob.url }}" target="_blank">{{ blob.name }}</a>
            </li>
            {% endfor %}
        </ul>
        </div>
        <div id="login">
        <p> Es admin?</p>
        <form action="{{ url_for('login') }}">
           <button type="submit">Login</button>
        </form>
        </div>
    </body>
    </html>
EOT

cat << 'EOT' > /var/www/html/login.html
<html>
    <head>
        <title>Login</title>
    </head>
    <body>
        <h1>Login</h1>
        <form action="{{ url_for('login') }}" method="post">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            <input type="submit" value="Login">
        </form>
    </body>
</html>
EOT

cat << 'EOT' > /var/www/html/auth.html
    <html>
    <head>
        <title>Website</title>

    </head>
    <body>

        <h1>Website</h1>
        <ul>
            {% for blob in blobs %}
            <li>
                <a href="{{ blob.url }}" target="_blank">{{ blob.name }}</a>
                <form action="{{ url_for('delete file', file_name=blob.name) }}" method="post">
                    <button type="submit">Delete</button>
                </form>
            </li>
            {% endfor %}

        </ul>

        <form action="{{ url_for('upload_file) }}" method="post" enctype="multipart/form-data">
           <label for="file">Filename:</label>
           <input type="file" id="file" name="file" required>
            <button type="submit">Upload</button>
        </form>

        <p> Conta </p>
        <form action="{{ url_for('index') }}">
           <button type="submit">Logout</button>
        </form>
    </body>
    </html>
EOT

cat << 'EOT' > /var/www/html/auth_error.html
<html>
<html>
    <head>
        <title>Login</title>
    </head>
    <body>
        <h1>Login</h1>
        <p>Invalid username or password</p>
        <form action="{{ url_for('login') }}" method="post">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            <input type="submit" value="Login">
        </form>
    </body>
    </html>
EOT

cat << 'EOT' > /var/www/html/app.py
from flask import Flash, render_template, request, redirect, url_for, flash
from google.cloud import storage

app = Flask(__name__)
bucket_name = 'bucket-unique-bucket'

#Default
@app.route('/')
def index():
    client = storage.Client.from_service_account_json('keys.json')
    buckets = client.get_bucket(bucket_name)
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
    client = storage.Client.from_service_account_json('keys.json')
    buckets = client.get_bucket(bucket_name)
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
            client = storage.Client.from_service_account_json('keys.json')
            bucket = client.get_bucket(bucket_name)

            blob = bucket.blob(f.filename)
            blob.upload_from_string(f.read(), content_type=f.content_type)
            flash('File uploaded successfully')
        return redirect(url_for('auth'))
        


#Delete
@app.route('/delete/<file_name>', methods=['POST'])
def delete(file_name):
    client = storage.Client.from_service_account_json('keys.json')
    bucket = client.get_bucket(bucket_name)

    blob = bucket.blob(file_name)
    blob.delete()

    return redirect(url_for('auth'))


if __name__ == '__main__':
    app.run(debug=True)
EOT

cat << 'EOT' > /var/www/html/keys.json
{
  ""type": "service_account",
  "project_id": "projetocloud-417315",
  "private_key_id": "745fd69ca3784f01261a3024a9e902cc641e435c",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDBBYqlAQd0+le9\n9nfHEoASS+poXdRBpHnTM8yJ4j143gTpn879VaaFoAkaHl2/Ry8r+/jHyIA26f5N\nvO9m9cpNNDz79Yz/D/USOuIkry8uaKoU/rtN5Xmraw6AAd95zWQBbzSaZk/d6Jk1\ndoba7pow+9tRebxIHtgcQgea/mV7soCuJ1C+RlCEAt61ljlxHI6RDWPlShT0zaLZ\nplwXyxY6qwvLDlFSseVgapDA6l1nCOvpCXFQIMlABROtuCA1UFiFF2y9F7SacxhD\ngBdqLcePklYMWH62fsA/IQWayhL711XRF0/FuL44tHgWeg0FVHgnsN6FMAo7OgmY\nzigsEvxfAgMBAAECggEARvwIPF1QBjuIqBIrg3jww4nKp14WUJuxt7O9fVnH3Jrd\nuKMuRqlIh6zOnB3dwRnnJahRGfvI9yj/fkxEyJsMrm7PHKP1mdme+XjRMMeCNPGF\n1xnE/UUuhRVmbDoEGvGnXQWuFTgaGBRRv8EaoAoOh4Qf6Gs6DFXXiTDZRi1XWfEr\n5U1UYsdVlhs0+i2Avy57SmH641OuNZsrBrZpZ+9ZX0aqv5b8vJZKl/L68T/0/NB9\n55CqGxUFmUp02EgKzKdtlNTGCe/GhFmVkOlU2NFvxX355cBkyYCv49r5nFPdKmJZ\nnVMHCeV+2jYj6Ffj/gkHdx/L6REUUhgDwXBtz9lQEQKBgQDxd+yJkEj0FFeK6FxL\nRhFC5M6WpEzgDkcfA2v9eAU4FBj/yUZJOT4HzcG6mTd/DjPUB/zyJpFlQIYD8eNA\nkz/j9qtyzq2TJ9B5bauUYO14LisTyEblKt21pmzcjSMkC5QErRWaTi6aFxZaPR6K\ng02jogO/0DBFShXuY1SLUaQdUQKBgQDMoz5VluzFdvPg1/84LbJ3WzAajOQvzefR\nw7hj22EjdMs+p24oV0gPPNRoePTExbNABKAojimh4zs1U60H0X+iy5whoLqmN+FG\nEcOwiGVTbvWaHwnK2kiKyjaQW3IuNwZdNIGMX0owtehs0QxPfLXUJ3KtwcAoKGhh\nEDON589SrwKBgEjpak4beDvjTI/QG9ZK4Plu94Z7NA9PoGAX+2q86+6D+wx5bTS9\nCSL4GTBMBXrjAflbNCC2Tp7hPdZBGtqr29Xs7NYs3DKcChIwcGfMYMgyQKWniui1\n6d5o02RBZcQDjv1eejBuvRmgMQqse+VdQntPd4xaw8iYV0j1S1kKHOERAoGAHu5l\n06YWb9qFDm1XpHQzz5q28KxvKVKkQa6lxmI4kpVqyzOfkPVwbO0y5f+yb7O6XmjU\nlIy4ekHQh0T4mH/wHPlNxj93NvynTmINBDf5qNzSvtMGNeU8pc3e5X8NCTNEAP6Y\nvlEA88/rK9eFVtZw3XqA+QaaNve0n0dFo6NwUP0CgYAyJ7Dk8GfpdNOnbPby37Yn\nqu5jagHGHNNZEnZ7yZ2SRTdLE2YDsaMKXK4kcR8sEbYtYZhgBGwor40xmyDMX2vM\nXCbK0bODpu5ILZl8sZoiPizldvtlQjemsOpfKAYNSrUtJfgULYY47V4DMKHPU9ji\nWsFutr/ZzHVKkFiU47etOg==\n-----END PRIVATE KEY-----\n",
  "client_email": "terraform@projetocloud-417315.iam.gserviceaccount.com",
  "client_id": "104386956189662735894",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/terraform%40projetocloud-417315.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
  }
EOT

sudo chmod +x home/mjmarquespais/var/www/html/app.py

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

sudo cp /home/mjmarquespais/flask-app.service /etc/systemd/system/flask-app.service | sudo tee -a /var/log/startup-script.log

sudo systemctl daemon-reload | sudo tee -a /var/log/startup-script.log
sudo systemctl enable flask-app | sudo tee -a /var/log/startup-script.log
sudo systemctl start flask-app | sudo tee -a /var/log/startup-script.log