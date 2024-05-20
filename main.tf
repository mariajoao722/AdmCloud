# create VM's

resource "google_compute_instance" "html-instance-asia-east1-a" {
  name         = var.instance_name
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
   # network_ip = "10.204.0.10"

  }

  metadata = {
    ssh-keys = <<EOF
      monicaaaraujo_aa:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0sjyxepiun6vl+R3HfyidCAf9lWyjIReNI6gNkmEOymrZonIEmVRorms11Zwl+HU0774BYra3IEgMLmBRIh1k+jstUh1MwpR/ENg01U6OWG+IyzAtvMgXtpMPORM7wxV28O9zpvuNVSfZJtSNsE6UH8sBIlhiSM+MCCpgQaT2X7z43cWBvPHh3NNWSc/xK4B2yAFhj7bmH1WS1tx7jGj8oh8kGft2WPVuAmJrYLrzv+Fni1d0D5bAkDeSTPvb3+CO0IKiCBbV2y/tUIRBWxQVLJh9KXfpTHz5SfOje5k+Tla8eTsyR3JGQt/mIYEEJNFl0TVTGowtmL69w51yDwDETmPqjp3T1wgQQBa3NsNBuqz4mcPdToii/+1xzdm1lVaUYaPqot0IjK1HbFk5ZH2F9O1MIvpxpX1kuUF26FBgAALGYV0mpWrZRQ0seAEDFDGzHKfFsab3D0xcaq7j/LNhLMr7uCEIYLs7pEcs34PWRfl0yo5waDOTqm7D639C4gTsD/ZTyru2cShSGem5wPmBSvl8vSdnwbPEAiErkky/kaj4TPc3peu3XcqwxKeF3Zbje41YpN18zjDVs59xCmjbxRq0jpgePRpycDaBVuWbN/JUu/Xiaapzy1P5t2TBUCEpeDbHq7HiE8zwVcQkJ84uTrYYoVw47+dEJGuU00P52Q== admcloud_key
      mariajoao7:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0sjyxepiun6vl+R3HfyidCAf9lWyjIReNI6gNkmEOymrZonIEmVRorms11Zwl+HU0774BYra3IEgMLmBRIh1k+jstUh1MwpR/ENg01U6OWG+IyzAtvMgXtpMPORM7wxV28O9zpvuNVSfZJtSNsE6UH8sBIlhiSM+MCCpgQaT2X7z43cWBvPHh3NNWSc/xK4B2yAFhj7bmH1WS1tx7jGj8oh8kGft2WPVuAmJrYLrzv+Fni1d0D5bAkDeSTPvb3+CO0IKiCBbV2y/tUIRBWxQVLJh9KXfpTHz5SfOje5k+Tla8eTsyR3JGQt/mIYEEJNFl0TVTGowtmL69w51yDwDETmPqjp3T1wgQQBa3NsNBuqz4mcPdToii/+1xzdm1lVaUYaPqot0IjK1HbFk5ZH2F9O1MIvpxpX1kuUF26FBgAALGYV0mpWrZRQ0seAEDFDGzHKfFsab3D0xcaq7j/LNhLMr7uCEIYLs7pEcs34PWRfl0yo5waDOTqm7D639C4gTsD/ZTyru2cShSGem5wPmBSvl8vSdnwbPEAiErkky/kaj4TPc3peu3XcqwxKeF3Zbje41YpN18zjDVs59xCmjbxRq0jpgePRpycDaBVuWbN/JUu/Xiaapzy1P5t2TBUCEpeDbHq7HiE8zwVcQkJ84uTrYYoVw47+dEJGuU00P52Q== admcloud_key
    EOF
  }

  metadata_startup_script = file("scripts/http.sh")
}


resource "google_compute_instance" "video-instance-asia-east1-a" {
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
    #network_ip = "10.204.0.11"
  }

  metadata = {
    ssh-keys = <<EOF
      monicaaaraujo_aa:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0sjyxepiun6vl+R3HfyidCAf9lWyjIReNI6gNkmEOymrZonIEmVRorms11Zwl+HU0774BYra3IEgMLmBRIh1k+jstUh1MwpR/ENg01U6OWG+IyzAtvMgXtpMPORM7wxV28O9zpvuNVSfZJtSNsE6UH8sBIlhiSM+MCCpgQaT2X7z43cWBvPHh3NNWSc/xK4B2yAFhj7bmH1WS1tx7jGj8oh8kGft2WPVuAmJrYLrzv+Fni1d0D5bAkDeSTPvb3+CO0IKiCBbV2y/tUIRBWxQVLJh9KXfpTHz5SfOje5k+Tla8eTsyR3JGQt/mIYEEJNFl0TVTGowtmL69w51yDwDETmPqjp3T1wgQQBa3NsNBuqz4mcPdToii/+1xzdm1lVaUYaPqot0IjK1HbFk5ZH2F9O1MIvpxpX1kuUF26FBgAALGYV0mpWrZRQ0seAEDFDGzHKfFsab3D0xcaq7j/LNhLMr7uCEIYLs7pEcs34PWRfl0yo5waDOTqm7D639C4gTsD/ZTyru2cShSGem5wPmBSvl8vSdnwbPEAiErkky/kaj4TPc3peu3XcqwxKeF3Zbje41YpN18zjDVs59xCmjbxRq0jpgePRpycDaBVuWbN/JUu/Xiaapzy1P5t2TBUCEpeDbHq7HiE8zwVcQkJ84uTrYYoVw47+dEJGuU00P52Q== admcloud_key
      mariajoao7:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0sjyxepiun6vl+R3HfyidCAf9lWyjIReNI6gNkmEOymrZonIEmVRorms11Zwl+HU0774BYra3IEgMLmBRIh1k+jstUh1MwpR/ENg01U6OWG+IyzAtvMgXtpMPORM7wxV28O9zpvuNVSfZJtSNsE6UH8sBIlhiSM+MCCpgQaT2X7z43cWBvPHh3NNWSc/xK4B2yAFhj7bmH1WS1tx7jGj8oh8kGft2WPVuAmJrYLrzv+Fni1d0D5bAkDeSTPvb3+CO0IKiCBbV2y/tUIRBWxQVLJh9KXfpTHz5SfOje5k+Tla8eTsyR3JGQt/mIYEEJNFl0TVTGowtmL69w51yDwDETmPqjp3T1wgQQBa3NsNBuqz4mcPdToii/+1xzdm1lVaUYaPqot0IjK1HbFk5ZH2F9O1MIvpxpX1kuUF26FBgAALGYV0mpWrZRQ0seAEDFDGzHKfFsab3D0xcaq7j/LNhLMr7uCEIYLs7pEcs34PWRfl0yo5waDOTqm7D639C4gTsD/ZTyru2cShSGem5wPmBSvl8vSdnwbPEAiErkky/kaj4TPc3peu3XcqwxKeF3Zbje41YpN18zjDVs59xCmjbxRq0jpgePRpycDaBVuWbN/JUu/Xiaapzy1P5t2TBUCEpeDbHq7HiE8zwVcQkJ84uTrYYoVw47+dEJGuU00P52Q== admcloud_key
    EOF
  }

  metadata_startup_script = file("scripts/video.sh")

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
   # network_ip = "10.204.0.10"

  }

  metadata = {
    ssh-keys = <<EOF
      monicaaaraujo_aa:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0sjyxepiun6vl+R3HfyidCAf9lWyjIReNI6gNkmEOymrZonIEmVRorms11Zwl+HU0774BYra3IEgMLmBRIh1k+jstUh1MwpR/ENg01U6OWG+IyzAtvMgXtpMPORM7wxV28O9zpvuNVSfZJtSNsE6UH8sBIlhiSM+MCCpgQaT2X7z43cWBvPHh3NNWSc/xK4B2yAFhj7bmH1WS1tx7jGj8oh8kGft2WPVuAmJrYLrzv+Fni1d0D5bAkDeSTPvb3+CO0IKiCBbV2y/tUIRBWxQVLJh9KXfpTHz5SfOje5k+Tla8eTsyR3JGQt/mIYEEJNFl0TVTGowtmL69w51yDwDETmPqjp3T1wgQQBa3NsNBuqz4mcPdToii/+1xzdm1lVaUYaPqot0IjK1HbFk5ZH2F9O1MIvpxpX1kuUF26FBgAALGYV0mpWrZRQ0seAEDFDGzHKfFsab3D0xcaq7j/LNhLMr7uCEIYLs7pEcs34PWRfl0yo5waDOTqm7D639C4gTsD/ZTyru2cShSGem5wPmBSvl8vSdnwbPEAiErkky/kaj4TPc3peu3XcqwxKeF3Zbje41YpN18zjDVs59xCmjbxRq0jpgePRpycDaBVuWbN/JUu/Xiaapzy1P5t2TBUCEpeDbHq7HiE8zwVcQkJ84uTrYYoVw47+dEJGuU00P52Q== admcloud_key
      mariajoao7:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0sjyxepiun6vl+R3HfyidCAf9lWyjIReNI6gNkmEOymrZonIEmVRorms11Zwl+HU0774BYra3IEgMLmBRIh1k+jstUh1MwpR/ENg01U6OWG+IyzAtvMgXtpMPORM7wxV28O9zpvuNVSfZJtSNsE6UH8sBIlhiSM+MCCpgQaT2X7z43cWBvPHh3NNWSc/xK4B2yAFhj7bmH1WS1tx7jGj8oh8kGft2WPVuAmJrYLrzv+Fni1d0D5bAkDeSTPvb3+CO0IKiCBbV2y/tUIRBWxQVLJh9KXfpTHz5SfOje5k+Tla8eTsyR3JGQt/mIYEEJNFl0TVTGowtmL69w51yDwDETmPqjp3T1wgQQBa3NsNBuqz4mcPdToii/+1xzdm1lVaUYaPqot0IjK1HbFk5ZH2F9O1MIvpxpX1kuUF26FBgAALGYV0mpWrZRQ0seAEDFDGzHKfFsab3D0xcaq7j/LNhLMr7uCEIYLs7pEcs34PWRfl0yo5waDOTqm7D639C4gTsD/ZTyru2cShSGem5wPmBSvl8vSdnwbPEAiErkky/kaj4TPc3peu3XcqwxKeF3Zbje41YpN18zjDVs59xCmjbxRq0jpgePRpycDaBVuWbN/JUu/Xiaapzy1P5t2TBUCEpeDbHq7HiE8zwVcQkJ84uTrYYoVw47+dEJGuU00P52Q== admcloud_key
    EOF
  }

  metadata_startup_script = file("scripts/http.sh")
}


resource "google_compute_instance" "video-instance-us-central1-b" {
  name         = var.instance_name4
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
    #network_ip = "10.204.0.11"
  }

  metadata = {
    ssh-keys = <<EOF
      monicaaaraujo_aa:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0sjyxepiun6vl+R3HfyidCAf9lWyjIReNI6gNkmEOymrZonIEmVRorms11Zwl+HU0774BYra3IEgMLmBRIh1k+jstUh1MwpR/ENg01U6OWG+IyzAtvMgXtpMPORM7wxV28O9zpvuNVSfZJtSNsE6UH8sBIlhiSM+MCCpgQaT2X7z43cWBvPHh3NNWSc/xK4B2yAFhj7bmH1WS1tx7jGj8oh8kGft2WPVuAmJrYLrzv+Fni1d0D5bAkDeSTPvb3+CO0IKiCBbV2y/tUIRBWxQVLJh9KXfpTHz5SfOje5k+Tla8eTsyR3JGQt/mIYEEJNFl0TVTGowtmL69w51yDwDETmPqjp3T1wgQQBa3NsNBuqz4mcPdToii/+1xzdm1lVaUYaPqot0IjK1HbFk5ZH2F9O1MIvpxpX1kuUF26FBgAALGYV0mpWrZRQ0seAEDFDGzHKfFsab3D0xcaq7j/LNhLMr7uCEIYLs7pEcs34PWRfl0yo5waDOTqm7D639C4gTsD/ZTyru2cShSGem5wPmBSvl8vSdnwbPEAiErkky/kaj4TPc3peu3XcqwxKeF3Zbje41YpN18zjDVs59xCmjbxRq0jpgePRpycDaBVuWbN/JUu/Xiaapzy1P5t2TBUCEpeDbHq7HiE8zwVcQkJ84uTrYYoVw47+dEJGuU00P52Q== admcloud_key
      mariajoao7:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0sjyxepiun6vl+R3HfyidCAf9lWyjIReNI6gNkmEOymrZonIEmVRorms11Zwl+HU0774BYra3IEgMLmBRIh1k+jstUh1MwpR/ENg01U6OWG+IyzAtvMgXtpMPORM7wxV28O9zpvuNVSfZJtSNsE6UH8sBIlhiSM+MCCpgQaT2X7z43cWBvPHh3NNWSc/xK4B2yAFhj7bmH1WS1tx7jGj8oh8kGft2WPVuAmJrYLrzv+Fni1d0D5bAkDeSTPvb3+CO0IKiCBbV2y/tUIRBWxQVLJh9KXfpTHz5SfOje5k+Tla8eTsyR3JGQt/mIYEEJNFl0TVTGowtmL69w51yDwDETmPqjp3T1wgQQBa3NsNBuqz4mcPdToii/+1xzdm1lVaUYaPqot0IjK1HbFk5ZH2F9O1MIvpxpX1kuUF26FBgAALGYV0mpWrZRQ0seAEDFDGzHKfFsab3D0xcaq7j/LNhLMr7uCEIYLs7pEcs34PWRfl0yo5waDOTqm7D639C4gTsD/ZTyru2cShSGem5wPmBSvl8vSdnwbPEAiErkky/kaj4TPc3peu3XcqwxKeF3Zbje41YpN18zjDVs59xCmjbxRq0jpgePRpycDaBVuWbN/JUu/Xiaapzy1P5t2TBUCEpeDbHq7HiE8zwVcQkJ84uTrYYoVw47+dEJGuU00P52Q== admcloud_key
    EOF
  }

  metadata_startup_script = file("scripts/video.sh")

}

# Create instance groups

resource "google_compute_instance_group" "video-instance-group-us-central1-b" {
  name        = "vide-instance-group-us-central1-b"
  description = "Video US instance group"

  instances = [
    google_compute_instance.var.video_instance_us_central1_b.id,
  ]

  named_port {
    name = "http"
    port = "80"
  }

  zone = "us-central1-b"
}

resource "google_compute_instance_group" "html-instance-group-us-central1-b" {
  name        = "html-instance-group-us-central1-b"
  description = "HTML US instance group"

  instances = [
    google_compute_instance.var.html_instance_us_central1_b.id,
  ]

  named_port {
    name = "http"
    port = "80"
  }

  zone = "us-central1-b"
}

resource "google_compute_instance_group" "video-instance-group-asia-east1-a" {
  name        = "vide-instance-group-asia-east1-a"
  description = "Video Asia instance group"

  instances = [
    google_compute_instance.var.video-instance-asia-east1-a.id,
  ]

  named_port {
    name = "http"
    port = "80"
  }

  zone = "asia-east1-a"
}

resource "google_compute_instance_group" "html-instance-group-asia-east1-a" {
  name        = "html-instance-group-asia-east1-a"
  description = "HTML Asia instance group"

  instances = [
    google_compute_instance.var.html-instance-asia-east1-a.id,
  ]

  named_port {
    name = "http"
    port = "80"
  }

  zone = "asia-east1-a"
}

# Create health checks
resource "google_compute_health_check" "http-health-check" {
  name = "http-health-check"
  timeout_sec        = 5
  check_interval_sec = 5
  unhealthy_threshold = 2

  http_health_check {
    port = 80
  }
}

# Create a backend service
resource "google_compute_backend_service" "video-backend-service" {
  name                  = "video-backend-service"
  protocol              = "HTTP"
  health_checks = [google_compute_http_health_check.http-health-check.id]
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = google_compute_instance_group.video-instance-group-us-central1-b.self_link
  }

  backend {
    group = google_compute_instance_group.video-instance-group-asia-east1-a.self_link
  }
}

resource "google_compute_backend_service" "html-backend-service" {
  name                  = "html-backend-service"
  protocol              = "HTTP"
  health_checks = [google_compute_http_health_check.http-health-check.id]
  load_balancing_scheme = "EXTERNAL"
  
  backend {
    group = google_compute_instance_group.html-instance-group-us-central1-b.self_link
  }

  backend {
    group = google_compute_instance_group.html-instance-group-asia-east1-a.self_link
  }
}

# Create a URL map
resource "google_compute_url_map" "www-url-map" {
  name        = "www-url-map"
  description = "URL map "

  default_service = google_compute_backend_service.html-backend-service.id

  path_matcher {
    name            = "pathmap"

    path_rule {
      paths   = ["/video"]
      service = google_compute_backend_service.video-backend-service.id
    }

    path_rule {
      paths   = ["/video/*"]
      service = google_compute_backend_service.video-backend-service.id
    }
  }
}

# Create a target HTTP proxy
resource "google_compute_target_https_proxy" "www-target-http-proxy" {
  name             = "www-target-http-proxy"
  url_map          = google_compute_url_map.www-url-map.id
}