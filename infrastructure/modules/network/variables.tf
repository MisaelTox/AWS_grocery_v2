variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "aws_region" {
  description = "AWS region used to determine availability zones"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet (EC2)"
  type        = string
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for private subnet A (RDS)"
  type        = string
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for private subnet B (RDS)"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "List of CIDR blocks allowed to SSH into EC2"
  type        = list(string)
}

variable "allowed_http_cidrs" {
  description = "List of CIDR blocks allowed HTTP access to EC2"
  type        = list(string)
}