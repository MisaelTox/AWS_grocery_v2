##############################
# rds.tf
# RDS PostgreSQL setup 
##############################

## Subnet group for the RDS (2 private subnets in different AZs)
resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds-subnet-group"
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = merge(local.common_tags, { Name = "rds-subnet-group" })
}

# Instance RDS PostgreSQL
resource "aws_db_instance" "postgres" {
  identifier             = "grocerymate-db"
  engine                 = "postgres"
  engine_version         = "14.17"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  max_allocated_storage  = 25
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  storage_encrypted      = true

  tags = merge(local.common_tags, { Name = "grocerymate-rds" })
}


# Output for the RDS endpoint
output "db_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = aws_db_instance.postgres.address
}
