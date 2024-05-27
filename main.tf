# create VM's
resource "google_compute_instance" "html-instance-asia-east1-a" {
  name         = var.instance_name2
  machine_type = "e2-micro"
  zone         = "asia-east1-a"

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
    network_ip = "10.140.0.29"

  }

  metadata_startup_script = file("scripts/http.sh")
}

resource "google_compute_instance" "html-instance-us-central1-b" {
  name         = var.instance_name3
  machine_type = "e2-micro"
  zone         = "us-central1-b"

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
    network_ip = "10.128.0.31"

  }

  metadata_startup_script = file("scripts/http.sh")
}

resource "google_compute_instance" "html-instance-europe-west9-a" {
  name         = var.instance_name5
  machine_type = "e2-micro"
  zone         = "europe-west9-a"

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
    network_ip = "10.200.0.15"

  }

  metadata_startup_script = file("scripts/http.sh")
}

/*
resource "google_compute_instance" "cliente" {
  name         = "cliente"
  machine_type = "e2-micro"
  zone         = "europe-west9-a"

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
    network_ip = "10.200.0.16"

  }

  metadata_startup_script = file("scripts/http.sh")
}
*/

resource "google_compute_instance" "client-instance-1" {
  name = var.instance_client_1
  machine_type = "e2-micro"
  zone         = "europe-west9-a"


  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {}
    network_ip = "10.200.0.51"

  }

  metadata_startup_script = file("scripts/client.sh")
}

resource "google_compute_instance" "client-instance-2" {
  name = var.instance_client_2
  machine_type = "e2-micro"
  zone         = "europe-west9-a"


  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {}
         
    network_ip = "10.200.0.52"

  }

  metadata_startup_script = file("scripts/cl.sh")
}

resource "google_compute_instance" "client-instance-3" {
  name = var.instance_client_3
  machine_type = "e2-micro"
  zone         = "europe-west9-a"


  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {}
         
    network_ip = "10.200.0.53"

  }

  metadata_startup_script = file("scripts/client.sh")
}

# Create instance groups
resource "google_compute_instance_group" "html-instance-group-us" {
  name        = "html-instance-group-us"
  description = "HTML US instance group"

  instances = [
    google_compute_instance.html-instance-us-central1-b.id,

  ]

  named_port {
    name = "http"
    port = "80"
  }

  zone = "us-central1-b"
}

resource "google_compute_instance_group" "html-instance-group-asia" {
  name        = "html-instance-group-asia"
  description = "HTML Asia instance group"

  instances = [
    google_compute_instance.html-instance-asia-east1-a.id,
  ]

  named_port {
    name = "http"
    port = "80"
  }

  zone = "asia-east1-a"
}

resource "google_compute_instance_group" "html-instance-group-europe" {
  name        = "html-instance-group-europe"
  description = "HTML Europe instance group"

  instances = [
    google_compute_instance.html-instance-europe-west9-a.id,
  ]

  named_port {
    name = "http"
    port = "80"
  }

  zone = "europe-west9-a"
}

# Create health checks
resource "google_compute_http_health_check" "http-health-check" {
  name = "http-health-check"
  timeout_sec        = 5
  check_interval_sec = 5
  unhealthy_threshold = 2
  port = 80
  
}

# Create a backend service
resource "google_compute_backend_service" "html-backend-service" {
  name                  = "html-backend-service"
  protocol              = "HTTP"
  health_checks = [google_compute_http_health_check.http-health-check.id]
  load_balancing_scheme = "EXTERNAL"
  
  backend {
    group = google_compute_instance_group.html-instance-group-us.self_link
    balancing_mode    = "UTILIZATION"
    max_utilization   = 0.8
    capacity_scaler   = 1
  }

  backend {
    group = google_compute_instance_group.html-instance-group-asia.self_link
    balancing_mode    = "UTILIZATION"
    max_utilization   = 0.8
    capacity_scaler   = 1
  }

  backend {
    group = google_compute_instance_group.html-instance-group-europe.self_link
    balancing_mode    = "UTILIZATION"
    max_utilization   = 0.8
    capacity_scaler   = 1
  }

}

# Create a URL map / load balance
resource "google_compute_url_map" "www-url-map" {
  name        = "www-url-map"
  description = "URL map"

  default_service = google_compute_backend_service.html-backend-service.id
}

//NO TERMINAL
# Create a target HTTP proxy
/*resource "google_compute_target_https_proxy" "www-target-http-proxy" {
  name             = "www-target-http-proxy"
  url_map          = google_compute_url_map.www-url-map.id
}*/

# Create a global IP address
resource "google_compute_global_address" "ipv4_address" {
  name          = "ipv4-address"
  ip_version    = "IPV4"
}

/* NO TERMINAL
# Retrieve the created IPv4 address
data "google_compute_global_address" "ipv4_address_info" {
  name = google_compute_global_address.ipv4_address.name
}
/*
# Create a global forwarding rule
resource "google_compute_global_forwarding_rule" "www_forwarding_rule_ipv4" {
  name        = "www-forwarding-rule-ipv4"
  ip_address  = google_compute_global_address.ipv4_address.address
  target      = google_compute_target_https_proxy.www-target-http-proxy.id
  port_range  = "80"
}*/

# Create a firewall rule meter para cada localização
resource "google_compute_firewall" "www-firewall-rule-us" {
  name    = "www-firewall-rule-us"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80","443","22"]
  }

  source_ranges = [
    "0.0.0.0/0"       
  ]
}

resource "google_compute_firewall" "www-firewall-rule-eu" {
  name    = "www-firewall-rule-eu"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80","443","22"]
  }

  source_ranges = [
    "0.0.0.0/0",        
  ]
}

resource "google_compute_firewall" "www-firewall-rule-aisa" {
  name    = "www-firewall-rule-asia"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80","443","22"]
  }

  source_ranges = [
    "0.0.0.0/0",        
  ]
}

# Create a storage bucket
resource "google_storage_bucket" "projetocloud-417315" {
  name     = "bucket-unique-bucket"
  location = "ASIA"
  uniform_bucket_level_access = true
  storage_class = "STANDARD"
}

# Grant object viewer permission to all users
resource "google_storage_bucket_iam_binding" "object_viewers" {
  bucket = google_storage_bucket.projetocloud-417315.name
  role   = "roles/storage.objectViewer"
  members = ["allUsers"]
  
}

# Create a bucket object
resource "google_storage_bucket_object" "image_object" {
  name   = "static/1.jpeg"  // Name of the image object in the bucket
  bucket = google_storage_bucket.projetocloud-417315.name
  source = "images/1.jpeg"  // Path to the image object in the local file system
}
resource "google_storage_bucket_object" "image_object1" {
  name   = "static/2.jpeg"  // Name of the image object in the bucket
  bucket = google_storage_bucket.projetocloud-417315.name
  source = "images/2.jpeg"  // Path to the image object in the local file system
}
resource "google_storage_bucket_object" "image_object2" {
  name   = "static/3.jpeg"  // Name of the image object in the bucket
  bucket = google_storage_bucket.projetocloud-417315.name
  source = "images/3.jpeg"  // Path to the image object in the local file system
}
resource "google_storage_bucket_object" "image_object3" {
  name   = "static/4.jpeg"  // Name of the image object in the bucket
  bucket = google_storage_bucket.projetocloud-417315.name
  source = "images/4.jpeg"  // Path to the image object in the local file system
}
resource "google_storage_bucket_object" "image_object4" {
  name   = "static/5.jpeg"  // Name of the image object in the bucket
  bucket = google_storage_bucket.projetocloud-417315.name
  source = "images/5.jpeg"  // Path to the image object in the local file system
}

resource "google_storage_bucket_object" "image_object5" {
  name   = "static/6.jpeg"  // Name of the image object in the bucket
  bucket = google_storage_bucket.projetocloud-417315.name
  source = "images/6.jpeg"  // Path to the image object in the local file system
}

# Create a static backend bucket
resource "google_compute_backend_bucket" "static-backend-bucket" {
  name          = "static-backend-bucket"
  bucket_name   = google_storage_bucket.projetocloud-417315.name
  enable_cdn    = false
}

// change url map NO TERMINAL