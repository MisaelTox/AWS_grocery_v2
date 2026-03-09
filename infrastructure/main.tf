##########################################
# MAIN CONFIGURATION FILE
# Cloud Engineering Project 
# Linux Environment (Amazon Linux 2)
##########################################

# Data block - Get AWS account info
data "aws_caller_identity" "current" {}



##########################################
#  Modules
##########################################

# Network Module
module "network" {
  source = "./modules/network"

  project_name = var.project_name
  aws_region   = var.aws_region

  vpc_cidr_block        = var.vpc_cidr_block
  public_subnet_cidr    = var.public_subnet_cidr
  private_subnet_cidr_a = var.private_subnet_cidr_a
  private_subnet_cidr_b = var.private_subnet_cidr_b

  common_tags        = var.common_tags
  allowed_ssh_cidrs  = var.allowed_ssh_cidrs
  allowed_http_cidrs = var.allowed_http_cidrs
}

# Storage Module (S3)
module "storage" {
  source = "./modules/storage"

  bucket_name = var.bucket_name
  common_tags = var.common_tags
}

# IAM Module (depends on S3 bucket)
module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
  common_tags  = var.common_tags

  s3_bucket_arn = module.storage.bucket_arn
}


# CloudWatch Module
module "cloudwatch" {
  source = "./modules/cloudwatch"

  project_name       = var.project_name
  common_tags        = var.common_tags
  log_group_name     = "/aws/flask/grocerymate"
  log_retention_days = 14
}

# Database Module
module "database" {
  source = "./modules/database"

  project_name = var.project_name
  common_tags  = var.common_tags

  subnet_ids             = module.network.private_subnet_ids
  vpc_security_group_ids = [module.network.rds_sg_id]

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

# Compute Module (EC2)
module "compute" {
  source = "./modules/compute"

  project_name = var.project_name
  common_tags  = var.common_tags

  instance_type          = var.instance_type
  subnet_id              = module.network.public_subnet_id
  vpc_security_group_ids = [module.network.ec2_sg_id]
  key_name               = var.key_name

  iam_instance_profile = module.cloudwatch.instance_profile_name

  db_host     = module.database.rds_endpoint
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

