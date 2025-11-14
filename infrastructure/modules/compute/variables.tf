variable "project_name" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "key_name" {
  type = string
}

variable "iam_instance_profile" {
  type = string
}

# ---- DB variables for user_data ----
variable "db_host" {
  type = string
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
