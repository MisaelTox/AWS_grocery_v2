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
