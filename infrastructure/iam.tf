##################################
# IAM Role and Policy for EC2 <-> S3 Access
##################################

resource "aws_iam_role" "ec2_role" {
  name = "grocerymate-ec2-role"

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

  tags = merge(local.common_tags, { Name = "grocerymate-ec2-role" })
}

resource "aws_iam_role_policy" "ec2_s3_policy" {
  name = "grocerymate-ec2-s3-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # S3 Bucket Access
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = [aws_s3_bucket.grocerymate_bucket.arn]
      },
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = ["${aws_s3_bucket.grocerymate_bucket.arn}/*"]
      },
      # Optional: CloudWatch Logs
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      # Optional: Enforce HTTPS for S3
      {
        Effect   = "Deny"
        Action   = ["s3:*"]
        Resource = ["${aws_s3_bucket.grocerymate_bucket.arn}/*"]
        Condition = {
          Bool = { "aws:SecureTransport" = "false" }
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "grocerymate-ec2-profile"
  role = aws_iam_role.ec2_role.name
}
