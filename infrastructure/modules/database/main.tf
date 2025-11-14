###############################################
# DATABASE MODULE - RDS PostgreSQL
###############################################

# -----------------------------
# RDS Subnet Group
# -----------------------------
resource "aws_db_subnet_group" "rds_subnet_group" {
name = "${lower(var.project_name)}-rds-subnet-group"

  # Las subnets vienen desde root como variable
  subnet_ids = var.subnet_ids

  tags = merge(var.common_tags, { Name = "${var.project_name}-rds-subnet-group" })
}

# -----------------------------
# RDS PostgreSQL Instance
# -----------------------------
resource "aws_db_instance" "postgres" {
identifier = "${replace(lower(var.project_name), "/[^a-z0-9-]/", "-")}-db"
  engine                 = "postgres"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.max_allocated_storage

  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password

  # El subnet group viene del recurso anterior
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  # SG para permitir acceso solo desde EC2
  vpc_security_group_ids = var.vpc_security_group_ids

  skip_final_snapshot    = true
  publicly_accessible    = false
  storage_encrypted      = true

  tags = merge(var.common_tags, { Name = "${var.project_name}-rds" })
}
