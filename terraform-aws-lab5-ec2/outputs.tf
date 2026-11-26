output "asg_names" {
  value = { for k, m in module.asg : k => m.asg_name }
}

output "target_group_arns" {
  value = { for k, m in module.asg : k => m.target_group_arns }
}
