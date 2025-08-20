terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend configuration placeholder
  backend "s3" {
    bucket = "your-terraform-state-bucket"
  }
}

provider "aws" {
  # Default tags
  default_tags {
    tags = {
      Environment = var.env
      Terraform   = "true"
      Service     = "SIEM"
    }
  }

}