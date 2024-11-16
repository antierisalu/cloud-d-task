provider "aws" {
    region = var.region 
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "day4-terrabuk-4"
}