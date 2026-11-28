locals {
  prefix   = "student_${var.student_a}_${var.student_b}" # student_9_3
  ssm_path = "/lab6/db/${local.prefix}"
}

data "aws_vpc" "lab" {
  filter {
    name   = "tag:Name"
    values = ["Lab5-6"]
  }
}

# --- Private subnets: RDS needs at least 2 AZs -----------------------------
# AZ a: the Lab 5 private subnet (fetched by data source)
data "aws_subnet" "private_a" {
  filter {
    name   = "tag:Name"
    values = ["student_3_9_Private"] # 192.168.3.0/24, eu-west-3a
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.lab.id]
  }
}

# AZ b: new private subnet (no public IP)
resource "aws_subnet" "private_b" {
  vpc_id            = data.aws_vpc.lab.id
  cidr_block        = "192.168.209.0/24"
  availability_zone = "eu-west-3b"

  tags = { Name = "${local.prefix}_Private_b" }
}

resource "aws_db_subnet_group" "this" {
  name       = "${replace(local.prefix, "_", "-")}-db-subnets"
  subnet_ids = [data.aws_subnet.private_a.id, aws_subnet.private_b.id]
}

# --- RDS security group -------------------------------------------------
resource "aws_security_group" "rds" {
  name        = "${local.prefix}_rds"
  description = "PostgreSQL from the bastion SG only"
  vpc_id      = data.aws_vpc.lab.id

  tags = { Name = "${local.prefix}_rds" }
}

# Step 3: Student B's SG, found by its agreed name
data "aws_security_group" "bastion" {
  count = var.bastion_ready ? 1 : 0

  filter {
    name   = "group-name"
    values = ["${local.prefix}_bastion"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.lab.id]
  }
}

resource "aws_vpc_security_group_ingress_rule" "from_bastion" {
  count = var.bastion_ready ? 1 : 0

  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = data.aws_security_group.bastion[0].id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
  description                  = "PostgreSQL from bastion"
}

# --- RDS PostgreSQL ------------------------------------------------------
resource "random_password" "db" {
  length           = 24
  special          = true
  override_special = "!#%^*()-_=+[]{}:?" # RDS forbids / @ " and spaces
}

resource "aws_db_instance" "this" {
  identifier     = "${replace(local.prefix, "_", "-")}-db"
  engine         = "postgres"
  engine_version = var.postgres_version
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp2"
  storage_encrypted = true

  db_name  = "labdb"
  username = "labadmin"
  password = random_password.db.result
  port     = 5432

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false
  multi_az               = false

  backup_retention_period = 0
  skip_final_snapshot     = true # otherwise destroy fails
  deletion_protection     = false
  apply_immediately       = true
}

# --- SSM parameters (contract with Student B) ----------------------------
resource "aws_ssm_parameter" "db" {
  for_each = {
    host     = aws_db_instance.this.address # host only, WITHOUT ":5432"
    port     = tostring(aws_db_instance.this.port)
    dbname   = aws_db_instance.this.db_name
    username = aws_db_instance.this.username
  }

  name  = "${local.ssm_path}/${each.key}"
  type  = "String"
  value = each.value
}

resource "aws_ssm_parameter" "password" {
  name  = "${local.ssm_path}/password"
  type  = "SecureString" # encrypted with the default aws/ssm KMS key
  value = random_password.db.result
}
