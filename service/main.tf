terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.22.0"
    }
  }
  backend "s3" {
    bucket         = "tungtt-terraform-state-staging"
    key            = "services/terraform.tfstate"
    region         = "ap-southeast-1"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c802847a7dd848c0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.terraform_remote_state.networking.outputs.sg-id]
  tags = {
    Name = "HelloWorld"
  }
}

data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket         = "tungtt-terraform-state-staging"
    key            = "vpc/terraform.tfstate"
    region         = "ap-southeast-1"
  }
}