terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.18.0"
    }
  }

  required_version = ">=1.5.0"
}

provider "aws" {
  region  = var.region
  profile = "AdministratorAccess-197710836519"
}