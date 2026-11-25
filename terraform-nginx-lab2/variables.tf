variable "image" {
  description = "Image Docker à utiliser"
  type        = string
  default     = "nginx:latest"
}

variable "memory" {
  description = "Limite mémoire des conteneurs en Mo (0 = pas de limite)"
  type        = number
  default     = 512

  validation {
    condition     = var.memory >= 0
    error_message = "memory doit être supérieur ou égal à 0."
  }
}

variable "privileged" {
  description = "Lancer les conteneurs en mode privilégié"
  type        = bool
  default     = false
}

variable "container_count" {
  description = "Nombre de conteneurs à créer"
  type        = number
  default     = 1

  validation {
    condition     = var.container_count >= 1
    error_message = "container_count doit être au moins égal à 1."
  }
}

variable "name_prefix" {
  description = "Préfixe des noms de conteneurs (ex. nginx -> nginx-0, nginx-1, ...)"
  type        = string
  default     = "nginx"
}

variable "start_port" {
  description = "Port hôte du premier conteneur ; les suivants prennent les ports suivants"
  type        = number
  default     = 8000

  validation {
    condition     = var.start_port >= 1 && var.start_port <= 65535
    error_message = "start_port doit être compris entre 1 et 65535."
  }
}

variable "hostname_page" {
  description = "Afficher le hostname du conteneur sur la page d'accueil (nécessite une image nginx)"
  type        = bool
  default     = true
}