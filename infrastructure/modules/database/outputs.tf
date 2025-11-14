###############################################
# OUTPUTS - DATABASE MODULE
###############################################

output "rds_endpoint" {
  description = "RDS endpoint address"
  value       = aws_db_instance.postgres.address
}
