output "instance_id" {
  description = "The ID of instance 1"
  value       = google_compute_instance.teste1.instance_id
}

output "instance_id2" {
  description = "The ID of instance 2"
  value       = google_compute_instance.teste2.instance_id
}

