##########################################
# MAIN CONFIGURATION FILE
# Cloud Engineering Project - Masterschool
# Linux Environment (Amazon Linux 2)
##########################################

# 1️⃣ Data block - Get AWS account info
data "aws_caller_identity" "current" {}

output "aws_account_id" {
  description = "AWS Account ID used for this deployment"
  value       = data.aws_caller_identity.current.account_id
}

##########################################
# 2️⃣ Outputs for Reference
##########################################


output "rds_endpoint" {
  description = "Endpoint of the RDS PostgreSQL database"
  value       = aws_db_instance.postgres.address
}

