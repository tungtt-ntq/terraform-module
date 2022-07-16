terraform {
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}

resource "aws_s3_bucket" "terraform_state-staging" {
  bucket = "tungtt-terraform-state-staging"
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = true
  }
}