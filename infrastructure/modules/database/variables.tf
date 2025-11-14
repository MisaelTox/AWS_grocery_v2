###############################################
# VARIABLES - DATABASE MODULE
###############################################

variable "project_name" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "subnet_ids" {
  description = "Private subnets for RDS (list)"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "Security group IDs allowed to access RDS"
  type        = list(string)
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "engine_version" {
  type    = string
  default = "14.17"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "max_allocated_storage" {
  type    = number
  default = 25
}
