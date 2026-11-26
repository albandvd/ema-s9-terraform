locals {
  vpc_id    = "vpc-01b6138c71cc82aba"
  subnet_id = "subnet-0855fbfcf29f845c3"
  ami_id    = "ami-092c64119783c2f31"
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
  vpc_id      = local.vpc_id

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

resource "aws_instance" "this" {
  ami                    = local.ami_id
  instance_type          = "t2.micro"
  subnet_id              = local.subnet_id
  key_name               = aws_key_pair.ssh.key_name
  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name = "student9-lab3"
  }
}
