data "aws_vpc" "lab56" {
  filter {
    name   = "tag:Name"
    values = ["Lab5-6"]
  }
}

data "aws_subnet" "private" {
  filter {
    name   = "tag:Name"
    values = ["student_3_9_Private"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.lab56.id]
  }
}

data "aws_security_group" "internal" {
  filter {
    name   = "group-name"
    values = ["student_3_9_internal"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.lab56.id]
  }
}

data "aws_ami" "al2023" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

data "aws_lb_target_group" "nginx" {
  name = "student-3-9-alb-nginx"
}

data "aws_lb_target_group" "tomcat" {
  name = "student-3-9-alb-tomcat"
}

locals {
  apps = toset(["nginx", "tomcat"])

  target_group_arns = {
    nginx  = data.aws_lb_target_group.nginx.arn
    tomcat = data.aws_lb_target_group.tomcat.arn
  }
}

module "asg" {
  for_each = local.apps
  source   = "./modules/asg-web"

  name               = "student3-9-${each.key}"
  ami_id             = data.aws_ami.al2023.id
  instance_type      = var.instance_type
  min_size           = 2
  max_size           = 2
  subnet_ids         = [data.aws_subnet.private.id]
  security_group_ids = [data.aws_security_group.internal.id]
  create_alb         = false
  target_group_arns  = [local.target_group_arns[each.key]]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    TOKEN=$(curl -s -X PUT http://169.254.169.254/latest/api/token -H "X-aws-ec2-metadata-token-ttl-seconds: 300")
    ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
    mkdir -p /srv/${each.key}
    echo "<h1>${each.key}</h1><p>served by $ID</p>" | tee /srv/index.html /srv/${each.key}/index.html
    cd /srv && nohup python3 -m http.server 80 >/dev/null 2>&1 &
  EOF
  )
}
