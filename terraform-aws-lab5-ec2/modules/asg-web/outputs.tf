output "asg_name" {
  value = aws_autoscaling_group.this.name
}

output "target_group_arns" {
  value = local.target_group_arns
}

output "alb_dns_name" {
  value = var.create_alb ? aws_lb.this[0].dns_name : null
}
