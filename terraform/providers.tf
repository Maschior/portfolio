terraform {
  required_version = ">= 1.5"

  backend "s3" {
    bucket         = "maschior-terraform-state"
    key            = "state/terraform.tfstate"
    region         = "sa-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.44.0"
    }


    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      project    = var.project_name
      managed_by = "terraform"
    }
  }
}