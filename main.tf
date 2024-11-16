provider "aws" {
    region = "us-east-1"
}

module "s3_bucket" {
    source = "./modules/s3"
    region = "us-east-1"
}

module "db_instance" {
    source = "./modules/db"
    region = "us-east-1"
}

module "ec2_instance" {
    source = "./modules/ec2"
    region = "us-east-1"
    instance_type     = "t2.micro"
    ami_id     = "ami-0866a3c8686eaeeba" # Ubuntu 24.04
    key_name     = "aws-keypair"
}

output "public_ip" {
    value = module.ec2_instance.public_ip
}