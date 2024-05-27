from flask import Flash, render_template, request, redirect, url_for, flash
from google.cloud import storage

app = Flask(__name__)
bucket_name = 'bucket-unique-bucket'

#Default
@app.route('/')
def index():
    client = storage.Client.from_service_account_json('keys.json')
    buckets = client.buckets(bucket_name)
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
    buckets = client.buckets(bucket_name)
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