##################################
# iam.tf
# IAM Role and Policy for EC2 <-> S3 Access
##################################

# Rol IAM para EC2
resource "aws_iam_role" "ec2_role" {
  name = "grocerymate-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(local.common_tags, { Name = "grocerymate-ec2-role" })
}

# Política: Permitir acceso solo al bucket S3 de GroceryMate
resource "aws_iam_role_policy" "ec2_s3_policy" {
  name = "grocerymate-ec2-s3-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.grocerymate_bucket.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${aws_s3_bucket.grocerymate_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Instancia de perfil para EC2 (vincula el rol)
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "grocerymate-ec2-profile"
  role = aws_iam_role.ec2_role.name
}
