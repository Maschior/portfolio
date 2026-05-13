terraform {
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
  region = "sa-east-1"
}

provider "cloudflare" {}