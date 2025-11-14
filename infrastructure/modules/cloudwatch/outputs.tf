output "log_group_name" {
  description = "CloudWatch Log Group Name"
  value       = aws_cloudwatch_log_group.app_log_group.name
}

output "instance_profile_name" {
  description = "IAM Instance Profile for CloudWatch Agent"
  value       = aws_iam_instance_profile.cloudwatch_instance_profile.name
}

output "role_name" {
  description = "IAM Role used by CloudWatch Agent"
  value       = aws_iam_role.cloudwatch_role.name
}
