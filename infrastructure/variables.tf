variable "region" {
  type        = string
  description = "AWS region to deploy resources in"
}

variable "project_name" {
  description = "Project name for tagging resources"
  default     = "grocerymate-v2"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, staging, prod)"
  default     = "dev"
}

variable "db_username" {
  description = "Usuario para la base de datos RDS"
  default     = "admin"
}

variable "db_password" {
  description = "Contraseña para la base de datos RDS"
  sensitive   = true
}

variable "instance_type" {
  default = "t3.micro"
}

variable "aws_profile" {
  type        = string
  description = "Optional AWS CLI profile for local development"
  default     = ""
}
