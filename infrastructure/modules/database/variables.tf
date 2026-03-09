variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "db_name" {
  description = "Name of the PostgreSQL database"
  type        = string
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
}

variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "14.17"
}

variable "instance_class" {
  description = "RDS instance class (e.g. db.t3.micro)"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Initial allocated storage in GB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum storage autoscaling limit in GB"
  type        = number
  default     = 25
}

variable "subnet_ids" {
  description = "Private subnets for RDS (list)"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "Security group IDs allowed to access RDS"
  type        = list(string)
}