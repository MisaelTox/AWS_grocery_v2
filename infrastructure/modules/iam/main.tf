##################################
# IAM Role for EC2
##################################

resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = { Service = "ec2.amazonaws.com" }
      }
    ]
  })

  force_detach_policies = true

  tags = merge(var.common_tags, { Name = "${var.project_name}-ec2-role" })

  lifecycle {
    create_before_destroy = true
  }
}

##################################
# Inline Policy: S3 + CloudWatch
##################################

resource "aws_iam_role_policy" "ec2_inline_policy" {
  name = "${var.project_name}-ec2-inline-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # S3 permissions
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = var.s3_bucket_arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${var.s3_bucket_arn}/*"
      },

      # CloudWatch logs
      # NOTE: Resource is "*" for simplicity. In production, scope this
# to a specific log group ARN for least privilege.
      
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },

      # Force HTTPS for S3
      {
        Effect   = "Deny"
        Action   = ["s3:*"]
        Resource = "${var.s3_bucket_arn}/*"
        Condition = {
          Bool = { "aws:SecureTransport" = false }
        }
      }
    ]
  })
}

##################################
# Instance Profile
##################################

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name

  tags = var.common_tags

  lifecycle {
    create_before_destroy = true
  }
}
