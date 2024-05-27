
output "public_ip_asia" {
  value = google_compute_instance.html-instance-asia-east1-a.network_interface[0].access_config[0].nat_ip
}

output "public_ip_us" {
  value = google_compute_instance.html-instance-us-central1-b.network_interface[0].access_config[0].nat_ip
}
output "public_ip_europe" {
  value = google_compute_instance.html-instance-europe-west9-a.network_interface[0].access_config[0].nat_ip
}

output "client_ip1" {
  value = google_compute_instance.client-instance-1.network_interface[0].access_config[0].nat_ip
}

output "client_ip2" {
  value = google_compute_instance.client-instance-2.network_interface[0].access_config[0].nat_ip
}

output "client_ip3" {
  value = google_compute_instance.client-instance-3.network_interface[0].access_config[0].nat_ip
}