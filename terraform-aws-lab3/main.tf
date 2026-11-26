data "aws_subnet" "this" {
  id = var.subnet_id
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
  key_name   = "student9-${terraform.workspace}-key"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "${path.module}/student9-${terraform.workspace}-key.pem"
  file_permission = "0600"
}

resource "aws_security_group" "ssh" {
  name        = "student9-${terraform.workspace}-ssh"
  description = "Allow SSH access for the lab4 ASG instances"
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
    Name = "student9-${terraform.workspace}-ssh"
  }
}

resource "aws_launch_template" "this" {
  name_prefix   = "student9-${terraform.workspace}-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ssh.key_name

  vpc_security_group_ids = [aws_security_group.ssh.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "student9-${terraform.workspace}-asg"
    }
  }
}

resource "aws_autoscaling_group" "this" {
  name                = "student9-${terraform.workspace}-asg"
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  desired_capacity    = var.asg_min_size
  vpc_zone_identifier = [data.aws_subnet.this.id]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "student9-${terraform.workspace}-asg"
    propagate_at_launch = true
  }
}
