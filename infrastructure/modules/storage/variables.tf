variable "bucket_name" {
  description = "The unique name of the S3 bucket"
  type        = string
}

variable "common_tags" {
  description = "Tags applied to all resources"
  type        = map(string)
}
