##########################################
# variables.tf
# Input variables for GroceryMate project
##########################################

# -------- General Configuration --------
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging and resource naming"
  type        = string
}

# -------- Tags --------
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

# -------- EC2 Configuration --------
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name for EC2"
  type        = string
}

# -------- RDS Configuration --------
variable "db_username" {
  description = "Database master username"
  type        = string
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
}

# -------- Networking --------
variable "vpc_cidr_block" {
  description = "Main VPC CIDR block"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = string
}

variable "private_subnet_cidr_a" {
  description = "Private subnet A CIDR block"
  type        = string
}

variable "private_subnet_cidr_b" {
  description = "Private subnet B CIDR block"
  type        = string
}

# -------- S3 Configuration --------
variable "bucket_name" {
  description = "Name of the S3 bucket for static/media storage"
  type        = string
}


# -------- Security Rules --------
variable "allowed_ssh_cidrs" {
  description = "List of CIDR blocks allowed to SSH into EC2"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_http_cidrs" {
  description = "List of CIDR blocks allowed to access HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
