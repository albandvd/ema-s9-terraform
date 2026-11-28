variable "student_a" {
  type    = number
  default = 9
}

variable "student_b" {
  type    = number
  default = 3
}

variable "bastion_ready" {
  description = "Step 1: false. Step 3 (once B has created its SG): true"
  type        = bool
  default     = false
}

variable "postgres_version" {
  description = "Subject asks 14.7; use \"14\" (latest 14.x) if 14.7 is no longer offered"
  type        = string
  default     = "14"
}
