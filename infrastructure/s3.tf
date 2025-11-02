##############################
# s3.tf
# bucket for static or media storage
##############################

# S3 Bucket 
resource "aws_s3_bucket" "grocerymate_bucket" {
  bucket        = local.full_bucket_name
  force_destroy = true

  tags = merge(local.common_tags, { Name = local.full_bucket_name })
}

# Block any public access
resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket                  = aws_s3_bucket.grocerymate_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.grocerymate_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Configure expiration of old versions (to reduce costs)
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.grocerymate_bucket.id

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

# Useful output to display the bucket name
output "s3_bucket_name" {
  description = "Nombre único del bucket S3 GroceryMate"
  value       = aws_s3_bucket.grocerymate_bucket.bucket
}
