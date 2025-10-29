resource "random_id" "bucket_suffix" {
  byte_length = 2
}

resource "aws_s3_bucket" "grocerymate_bucket" {
  bucket = "${var.project_name}-bucket-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.project_name}-bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_access" {
  bucket = aws_s3_bucket.grocerymate_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.grocerymate_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
