terraform {
  backend "s3" {
    bucket         = "terraform-state-w9e85"
    key            = "global/s3/student_9/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
    profile        = "ema-s9"
  }
}
