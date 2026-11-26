variable "name" {
  description = "Base name for the ASG, launch template, and (optionally) ALB"
  type        = string
}

variable "ami_id" {
  description = "AMI id to launch instances from"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  description = "Minimum size of the autoscaling group"
  type        = number
}

variable "max_size" {
  description = "Maximum size of the autoscaling group"
  type        = number
}

variable "subnet_ids" {
  description = "Subnets the ASG instances are launched into"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups attached to the ASG instances"
  type        = list(string)
}

variable "user_data" {
  description = "Base64-encoded user data for the launch template"
  type        = string
  default     = null
}

variable "key_name" {
  description = "Optional EC2 key pair name for SSH access"
  type        = string
  default     = null
}

variable "create_alb" {
  description = "Whether this module should create its own ALB in front of the ASG. Set to false to attach the ASG to externally-provided target_group_arns instead."
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "VPC id, required when create_alb is true (used for the target group)"
  type        = string
  default     = null
}

variable "alb_subnet_ids" {
  description = "Public subnets for the ALB, required when create_alb is true"
  type        = list(string)
  default     = []
}

variable "alb_security_group_ids" {
  description = "Security groups for the ALB, required when create_alb is true"
  type        = list(string)
  default     = []
}

variable "target_group_arns" {
  description = "Existing target group ARNs to attach the ASG to when create_alb is false"
  type        = list(string)
  default     = []
}
