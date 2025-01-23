terraform {
  required_version = "~> 1.10.4"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.40"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
