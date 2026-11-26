asg_min_size = 2
asg_max_size = 3

# Shared class account's eu-west-3 vCPU limit is exhausted; eu-north-1
# (default VPC/subnet) is used for this workspace per the lab's guidance.
# t2.micro isn't offered in eu-north-1, so t3.micro is used there instead.
region        = "eu-north-1"
subnet_id     = "subnet-0a8039e9a6ab8df5d"
instance_type = "t3.micro"
