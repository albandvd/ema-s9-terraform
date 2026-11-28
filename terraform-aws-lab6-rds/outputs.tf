output "rds_sg_id" {
  value = aws_security_group.rds.id
}

output "db_address" {
  value = aws_db_instance.this.address
}

output "db_engine_version" {
  value = aws_db_instance.this.engine_version_actual
}

output "ssm_path" {
  value = local.ssm_path
}

output "bastion_rule" {
  value = var.bastion_ready ? "5432 open from ${data.aws_security_group.bastion[0].id}" : "not yet (bastion_ready = false)"
}
