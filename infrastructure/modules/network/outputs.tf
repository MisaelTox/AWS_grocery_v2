output "public_subnet_id" {
  description = "ID of the public subnet where EC2 is deployed"
  value       = aws_subnet.public_a.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs for RDS subnet group"
  value       = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

output "ec2_sg_id" {
  description = "Security group ID attached to the EC2 instance"
  value       = aws_security_group.ec2_sg.id
}

output "rds_sg_id" {
  description = "Security group ID attached to the RDS instance"
  value       = aws_security_group.rds_sg.id
}