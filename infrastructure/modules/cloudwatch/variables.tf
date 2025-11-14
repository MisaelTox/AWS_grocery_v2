variable "project_name" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "log_group_name" {
  type        = string
  description = "Name of the CloudWatch Log Group"
}

variable "log_retention_days" {
  type        = number
  description = "Retention days for CloudWatch logs"
  default     = 14
}
