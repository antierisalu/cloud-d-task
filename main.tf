provider "aws" {
    region = "us-east-1"  # Set your desired AWS region
}

resource "aws_instance" "terraform_instance" {
    ami           = "ami-0866a3c8686eaeeba"  # Specify an appropriate AMI ID
    instance_type = "t2.micro"
    subnet_id = "subnet-07b6570bb4fb71ce8"
    key_name = "aws-keypair"
    security_groups = ["sg-0b543a82a9477b0c9"]
    associate_public_ip_address = true
}

# aws ec2 allocate-address

# aws ec2 associate-address --insta
# nce-id i-012302be6b6951c78 --allocation-id eipalloc-07e81fffb3d912389

# aws ec2 authorize-security-group-
# ingress --group-id sg-0b543a82a9477b0c9 --protocol tcp --port 22 --cidr 0.0.0
# .0/0

