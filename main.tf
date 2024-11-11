provider "aws" {
    region = "us-east-1"  # Set your desired AWS region
}

resource "aws_instance" "terraform_instance" {
    ami           = "ami-0866a3c8686eaeeba"  # Specify an appropriate AMI ID
    instance_type = "t2.micro"
    subnet_id = "subnet-07b6570bb4fb71ce8"
    key_name = "aws-keypair"
}