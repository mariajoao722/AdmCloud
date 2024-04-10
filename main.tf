# https://cloud.google.com/compute/docs/disks/add-persistent-disk?hl=pt-br#terraform

# Using pd-standard because it's the default for Compute Engine
# create new disk for some VM's
resource "google_compute_disk" "default" {
  name = "dbs"
  type = "pd-standard"
  zone = "europe-southwest1-c"
  size = "10"
}


# create VM's

resource "google_compute_instance" "teste1" {
  name         = var.instance_name
  machine_type = "e2-micro"
  zone         = "europe-southwest1-c"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  /*attached_disk {
    source      = google_compute_disk.default.id
    device_name = google_compute_disk.default.name
  }*/

  network_interface {
    network = "default"
    # Add access_config with a static external IP address
    access_config {
    }
    # Assign a static internal IP address
    network_ip = "10.204.0.10"

  }

  metadata = {
    ssh-keys = "${data.tls_public_key.public_key_data.public_key_pem}"
  }
}

resource "google_compute_instance" "teste2" {
  name         = var.instance_name2
  machine_type = "e2-micro"
  zone         = "europe-southwest1-c"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    # Add access_config with a static external IP address
    access_config {
    }
    # Assign a static internal IP address
    network_ip = "10.204.0.11"
  }

}

# Generate the SSH private key
# this key is efemeral so is destroy with terraform destroy and create with terraform apply

# RSA key of size 4096 bits
resource "tls_private_key" "ssh_key_pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}