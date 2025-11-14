output "bucket_name" {
  description = "The S3 bucket name"
  value       = aws_s3_bucket.bucket.bucket
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.bucket.arn
}
