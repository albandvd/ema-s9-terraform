output "container_names" {
  description = "Noms des conteneurs créés"
  value       = docker_container.this[*].name
}

output "container_ids" {
  description = "IDs des conteneurs créés"
  value       = docker_container.this[*].id
}

output "urls" {
  description = "URL de chaque conteneur"
  value       = [for i in range(var.container_count) : "http://localhost:${var.start_port + i}"]
}