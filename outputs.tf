output "instance_id" {
  description = "The ID of instance 1"
  value       = google_compute_instance.html-instance-asia-east1-a.instance_id
}

output "public_ip_asia" {
  value = google_compute_instance.html-instance-asia-east1-a.network_interface[0].access_config[0].nat_ip
}

output "public_ip_us" {
  value = google_compute_instance.html-instance-us-central1-b.network_interface[0].access_config[0].nat_ip
}
output "public_ip_europe" {
  value = google_compute_instance.html-instance-europe-west9-a.network_interface[0].access_config[0].nat_ip
}

output "client_ips" {
  value = google_compute_instance.client[*].network_interface[0].access_config[0].nat_ip
}