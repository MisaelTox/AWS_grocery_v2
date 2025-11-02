##############################
# variables.tf
# Terraform variables definition
##############################

# -----------------------------
# General
# -----------------------------
variable "aws_region" {
  description = "AWS region to deploy the infrastructure"
  type        = string
  default     = "eu-north-1"
}

# -----------------------------
# EC2 Configuration
# -----------------------------
variable "instance_type" {
  description = "EC2 instance type for the application (Free Tier eligible)"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the existing AWS key pair for SSH access"
  type        = string
}

# -----------------------------
# Random ID 
# -----------------------------
resource "random_id" "suffix" {
  byte_length = 2
}

# -----------------------------
# S3 Configuration
# -----------------------------
variable "bucket_name" {
  description = "Base name of the S3 bucket for storing user avatars or files"
  type        = string
  default     = "grocerymate-bucket"
}


locals {
  full_bucket_name = "${var.bucket_name}-${random_id.suffix.hex}"
}

# -----------------------------
# RDS Configuration
# -----------------------------
variable "db_username" {
  description = "RDS PostgreSQL username"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "RDS PostgreSQL password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name for the GroceryMate app"
  type        = string
  default     = "grocerymate"
}

# -----------------------------
# Networking
# -----------------------------
variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for the first private subnet (RDS AZ A)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for the second private subnet (RDS AZ B)"
  type        = string
  default     = "10.0.3.0/24"
}
