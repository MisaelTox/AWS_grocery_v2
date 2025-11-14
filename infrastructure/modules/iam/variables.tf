variable "project_name" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "s3_bucket_arn" {
  type = string
}
