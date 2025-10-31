##########################################
# MAIN CONFIGURATION FILE
# Cloud Engineering Project - Masterschool
# Linux Environment (Amazon Linux 2)
##########################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Get current AWS account info
data "aws_caller_identity" "current" {}

output "aws_account_id" {
  description = "AWS Account ID used for this deployment"
  value       = data.aws_caller_identity.current.account_id
}

# Network Module
module "network" {
  source = "./network"

  vpc_cidr_block      = var.vpc_cidr_block
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

# RDS Module
module "rds" {
  source = "./rds"

  vpc_id            = module.network.vpc_id
  subnet_ids        = module.network.private_subnets
  db_username       = var.db_username
  db_password       = var.db_password
  db_name           = var.db_name
  allocated_storage = 20
}

# EC2 Module
module "ec2" {
  source = "./ec2"

  vpc_id        = module.network.vpc_id
  subnet_id     = module.network.public_subnets[0]
  key_name      = var.key_name
  instance_type = var.instance_type
  ami_id        = data.aws_ami.amazon_linux.id

  user_data = templatefile("${path.module}/user_data.tpl", {
    db_host     = module.rds.db_endpoint
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
  })
}

# S3 Module
module "s3" {
  source      = "./s3"
  bucket_name = var.bucket_name
}

# Outputs
output "ec2_public_ip" {
  value       = module.ec2.public_ip
  description = "Public IP address of the EC2 instance"
}

output "rds_endpoint" {
  value       = module.rds.db_endpoint
  description = "RDS PostgreSQL endpoint"
}

output "s3_bucket_name" {
  value       = module.s3.bucket_name
  description = "Created S3 bucket name"
}
