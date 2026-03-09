variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "instance_type" {
  description = "EC2 instance type (e.g. t3.micro)"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to attach to the EC2 instance"
  type        = list(string)
}

variable "key_name" {
  description = "Name of the SSH key pair for EC2 access"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile name to attach to EC2"
  type        = string
}

variable "db_host" {
  description = "RDS endpoint hostname passed to user_data"
  type        = string
}

variable "db_name" {
  description = "PostgreSQL database name passed to user_data"
  type        = string
}

variable "db_username" {
  description = "PostgreSQL master username passed to user_data"
  type        = string
}

variable "db_password" {
  description = "PostgreSQL master password passed to user_data"
  type        = string
  sensitive   = true
}