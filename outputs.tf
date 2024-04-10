output "instance_id" {
  description = "The ID of instance 1"
  value       = google_compute_instance.teste1.instance_id
}

output "instance_id2" {
  description = "The ID of instance 2"
  value       = google_compute_instance.teste2.instance_id
}

output "public_ip_teste1" {
  value = google_compute_instance.teste1.network_interface[0].access_config[0].nat_ip
}

output "public_ip_teste2" {
  value = google_compute_instance.teste2.network_interface[0].access_config[0].nat_ip
}