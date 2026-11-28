terraform {
  backend "s3" {
    bucket         = "terraform-state-w9e85"
    key            = "student_9_3/network_rds.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
    profile        = "ema-s9"
  }
}
