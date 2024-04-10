output "instance_id" {
  description = "The ID of instance 1"
  value       = google_compute_instance.teste1.instance_id
}

output "instance_id2" {
  description = "The ID of instance 2"
  value       = google_compute_instance.teste2.instance_id
}

output "private_key" {
  value = tls_private_key.ssh_key_pk.private_key_pem
  sensitive=true
}

output "public_key" {
  value = "${data.tls_public_key.public_key_data.public_key_pem}"
  sensitive = true
}

output "public_ip_teste1" {
  value = google_compute_instance.teste1.network_interface[0].access_config[0].nat_ip
}