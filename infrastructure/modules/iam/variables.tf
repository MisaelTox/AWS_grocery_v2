variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket to grant EC2 access to"
  type        = string
}