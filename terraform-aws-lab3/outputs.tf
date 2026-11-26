output "instance_public_ip" {
  value = module.instance.public_ip
}

output "instance_public_dns" {
  value = module.instance.public_dns
}

output "ssh_command" {
  value = "ssh -i ${local_sensitive_file.private_key.filename} ec2-user@${module.instance.public_ip}"
}
