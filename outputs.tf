output "instance_id" {
  description = "The ID of instance 1"
  value       = google_compute_instance.html-instance-asia-east1-a.instance_id
}

output "instance_id2" {
  description = "The ID of instance 2"
  value       = google_compute_instance.video-instance-asia-east1-a.instance_id
}

output "public_ip_teste1" {
  value = google_compute_instance.html-instance-asia-east1-a.network_interface[0].access_config[0].nat_ip
}

output "public_ip_teste2" {
  value = google_compute_instance.video-instance-asia-east1-a.network_interface[0].access_config[0].nat_ip
}

output "ipv4_address" {
  value = data.google_compute_global_address.ipv4_address_info.address
}