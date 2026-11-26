variable "name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI id to launch the instance from"
  type        = string
}

variable "subnet_id" {
  description = "Subnet id to launch the instance in"
  type        = string
}

variable "security_group_ids" {
  description = "Security group ids to attach to the instance"
  type        = list(string)
}

variable "key_name" {
  description = "Name of the EC2 key pair to attach"
  type        = string
}
