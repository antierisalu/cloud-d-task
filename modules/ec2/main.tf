provider "aws" {
    region = var.region
}

resource "aws_vpc" "mainvpc" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mainvpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.mainvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.mainvpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "ssh_sg" {
  vpc_id = aws_vpc.mainvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "terraform_instance" {
    ami                         = var.ami_id
    instance_type               = var.instance_type
    subnet_id                   = aws_subnet.main_subnet.id
    key_name                    = var.key_name
    vpc_security_group_ids      = [aws_security_group.ssh_sg.id]
    associate_public_ip_address = true
}

resource "aws_eip" "lb" {
  instance = aws_instance.terraform_instance.id
  domain   = "vpc"
}