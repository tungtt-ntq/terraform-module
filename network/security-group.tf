terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.22.0"
    }
  }
  backend "s3" {
    bucket         = "tungtt-terraform-state-staging"
    key            = "vpc/terraform.tfstate"
    region         = "ap-southeast-1"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_security_group" "ec2-net-staging" {
  name        = "ec2-net"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-0f3f44d1989359822"

  ingress {
    description      = "Open port for web connection"
    from_port        = var.http-port
    to_port          = var.http-port
    protocol         = "tcp"
    cidr_blocks      = [var.cidr-block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ec2-net"
  }
}

variable "http-port" {
  type = number
  description = "Default http port"
  default = 80
}

variable "cidr-block" {
  type = string
  description = "My ip"
  default = "42.113.176.253/32"
}

output "sg-id" {
  value = aws_security_group.ec2-net-staging.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

output "availability-zone" {
  value = data.aws_availability_zones.available
}