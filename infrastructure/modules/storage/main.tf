###############################################
# STORAGE MODULE - S3 Bucket for Application Assets
###############################################

##########################
# S3 Bucket
##########################
resource "aws_s3_bucket" "bucket" {
  bucket        = lower(var.bucket_name)   # Ensures valid bucket naming
  force_destroy = true

  tags = merge(var.common_tags, { Name = lower(var.bucket_name) })
}

##########################
# Block Public Access
##########################
resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

##########################
# Enable Versioning
##########################
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

##########################
# Lifecycle Rules (expire old versions)
##########################
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.bucket.id

  depends_on = [
    aws_s3_bucket_versioning.versioning
  ]

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    filter {
      prefix = ""
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}
