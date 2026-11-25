# terraform-docker-nginx

Module Terraform qui lance un ou plusieurs conteneurs nginx sur Docker.

## Utilisation

module "nginx" {
  source          = "git::https://github.com/albandvd/ema-s9-terraform.git//terraform-nginx-lab2?ref=main"
  container_count = 2
  start_port      = 3000
}

## Variables

| Nom | Défaut | Description |
|---|---|---|
| image | nginx:latest | Image Docker |
| memory | 512 | Mémoire en Mo (0 = illimitée) |
| privileged | false | Mode privilégié |
| container_count | 1 | Nombre de conteneurs |
| name_prefix | nginx | Préfixe des noms |
| start_port | 8000 | Premier port hôte |
| hostname_page | true | Hostname affiché sur la page (image nginx) |

## Validation

- memory >= 0
- container_count >= 1
- start_port entre 1 et 65535

## Sorties

container_names, container_ids, urls