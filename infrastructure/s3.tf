##############################
# s3.tf
# Free-tier S3 bucket for static or media storage
##############################

resource "aws_s3_bucket" "grocerymate_bucket" {
  bucket = var.bucket_name
  tags   = merge(local.common_tags, { Name = "grocerymate-bucket" })
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket                  = aws_s3_bucket.grocerymate_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.grocerymate_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.grocerymate_bucket.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    filter {
      prefix = "" # applies to all objects
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}
