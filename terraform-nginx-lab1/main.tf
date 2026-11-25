terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Nombre de conteneurs nginx à créer
variable "nb_containers" {
  description = "Nombre de conteneurs nginx"
  type        = number
  default     = 2
}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  count = var.nb_containers

  name  = "nginx-lab1-${count.index}"
  image = docker_image.nginx.image_id

  # Écrit le hostname du conteneur dans la page d'accueil, puis lance nginx
  # (exec remplace le shell par nginx, qui reste au premier plan)
  command = [
    "/bin/sh", "-c",
    "echo \"<h1>Hostname : $(hostname)</h1>\" > /usr/share/nginx/html/index.html && exec nginx -g 'daemon off;'"
  ]

  ports {
    internal = 80
    external = 8000 + count.index # 8000, 8001, ...
  }
}

output "urls" {
  description = "URL de chaque conteneur"
  value       = [for i in range(var.nb_containers) : "http://localhost:${8000 + i}"]
}