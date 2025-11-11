# -----------------------------
# CloudWatch Log Group
# -----------------------------
resource "aws_cloudwatch_log_group" "flask_app_logs" {
  name              = "/aws/flask/grocerymate"
  retention_in_days = 14
  tags = {
    Project = "AWS_grocery_v2"
  }
}

# -----------------------------
# IAM Role for EC2 -> CloudWatch
# -----------------------------
resource "aws_iam_role" "ec2_cloudwatch_role" {
  name = "ec2-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach AWS managed policy for CloudWatch access
resource "aws_iam_role_policy_attachment" "cw_agent_policy_attach" {
  role       = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# -----------------------------
# Instance Profile (EC2 uses this)
# -----------------------------
resource "aws_iam_instance_profile" "ec2_cloudwatch_profile" {
  name = "ec2-cloudwatch-profile"
  role = aws_iam_role.ec2_cloudwatch_role.name
}
