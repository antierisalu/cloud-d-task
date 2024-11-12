provider "aws" {
    region = "us-east-1"
}

module "ec2_instance" {
    source = "./modules/ec2"
    region = "us-east-1"
    instance_type     = "t2.micro"
    ami_id     = "ami-0866a3c8686eaeeba" # Ubuntu 24.04
    key_name     = "aws-keypair"
}