output "asg_name" {
  value = aws_autoscaling_group.this.name
}

output "launch_template_id" {
  value = aws_launch_template.this.id
}

output "ssh_private_key_path" {
  value = local_sensitive_file.private_key.filename
}
