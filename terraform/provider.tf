terraform {
  required_version = ">= 1.5"

  backend "s3" {
    bucket         = "arenax-terraform-state"
    key            = "arenax/eks/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "arenax-terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
