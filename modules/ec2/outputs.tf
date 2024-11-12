output "public_ip" {
    description = "The public IP address of the instance"
    value = aws_instance.terraform_instance.public_ip
}