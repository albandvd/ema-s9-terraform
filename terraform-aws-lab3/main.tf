locals {
  vpc_id    = "vpc-01b6138c71cc82aba"
  subnet_id = "subnet-0855fbfcf29f845c3"
}

data "aws_subnet" "this" {
  id = local.subnet_id
}

data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  key_name   = "student9-lab3-key"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "${path.module}/student9-lab3-key.pem"
  file_permission = "0600"
}

resource "aws_security_group" "ssh" {
  name        = "student9-lab3-ssh"
  description = "Allow SSH access for lab3 EC2 instance"
  vpc_id      = data.aws_subnet.this.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "student9-lab3-ssh"
  }
}

module "instance" {
  source = "./modules/ec2-instance"

  name               = "student9-lab3"
  instance_type      = var.instance_type
  ami_id             = data.aws_ami.amazon_linux.id
  subnet_id          = data.aws_subnet.this.id
  key_name           = aws_key_pair.ssh.key_name
  security_group_ids = [aws_security_group.ssh.id]
}
