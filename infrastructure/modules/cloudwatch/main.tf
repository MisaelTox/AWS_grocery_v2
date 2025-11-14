###############################################
# CLOUDWATCH MODULE - Log Group + IAM Role
###############################################

##########################
# CloudWatch Log Group
##########################
resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = var.log_group_name
  retention_in_days = var.log_retention_days

  tags = merge(var.common_tags, {
    Name = var.log_group_name
  })

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [name]
  }
}

##########################
# IAM Role for CloudWatch Agent
##########################
resource "aws_iam_role" "cloudwatch_role" {
  name = "${var.project_name}-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-cloudwatch-role"
  })

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}


##########################
# Attach AWS Managed Policy for CloudWatch Agent
##########################
resource "aws_iam_role_policy_attachment" "cw_agent_policy" {
  role       = aws_iam_role.cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

##########################
# Instance Profile for EC2
##########################
resource "aws_iam_instance_profile" "cloudwatch_instance_profile" {
  name = "${var.project_name}-cloudwatch-profile"
  role = aws_iam_role.cloudwatch_role.name

  lifecycle {
    create_before_destroy = true
  }
}
