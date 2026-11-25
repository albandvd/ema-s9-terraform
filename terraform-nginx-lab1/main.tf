terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Se connecte au moteur Docker local (socket par défaut)
provider "docker" {}

# Télécharge l'image officielle nginx
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

# Crée et lance le conteneur
resource "docker_container" "nginx" {
  name  = "nginx-lab1"
  image = docker_image.nginx.image_id

  ports {
    internal = 80   # port dans le conteneur (nginx écoute sur 80)
    external = 8000 # port sur ta machine hôte
  }
}