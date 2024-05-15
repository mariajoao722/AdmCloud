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

resource "google_compute_instance" "html-instance-asia-east1-a" {
  name         = var.instance_name
  machine_type = "e2-micro"
  zone         = "asia-east1-a"

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