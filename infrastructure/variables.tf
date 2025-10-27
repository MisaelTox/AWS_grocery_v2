variable "region" {
  description = "AWS region to deploy resources"
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Project name for tagging resources"
  default     = "grocerymate-v2"
}

variable "environment" {
  description = "Environment type"
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