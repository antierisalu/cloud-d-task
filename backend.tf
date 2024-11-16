terraform {
  backend "s3" {
    bucket = "day4-terrabuk-4"
    key    = "ec2/terraform.tfstate"
    region = "us-east-1"
  }
}