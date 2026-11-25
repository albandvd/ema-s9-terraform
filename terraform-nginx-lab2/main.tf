resource "docker_image" "this" {
  name         = var.image
  keep_locally = false
}

resource "docker_container" "this" {
  count = var.container_count

  name       = "${var.name_prefix}-${count.index}"
  image      = docker_image.this.image_id
  memory     = var.memory
  privileged = var.privileged

  # Écrit le hostname dans la page d'accueil avant de lancer nginx (bonus lab 1)
  command = var.hostname_page ? [
    "/bin/sh", "-c",
    "echo \"<h1>Hostname : $(hostname)</h1>\" > /usr/share/nginx/html/index.html && exec nginx -g 'daemon off;'"
  ] : null

  ports {
    internal = 80
    external = var.start_port + count.index
  }
}