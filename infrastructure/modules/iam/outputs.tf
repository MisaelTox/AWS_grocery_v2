output "instance_profile_name" {
  description = "Name of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}

output "role_name" {
  description = "Name of the IAM role assigned to EC2"
  value       = aws_iam_role.ec2_role.name
}
