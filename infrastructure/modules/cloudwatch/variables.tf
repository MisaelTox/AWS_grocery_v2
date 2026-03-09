variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
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
