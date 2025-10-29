resource "random_id" "rds_suffix" {
  byte_length = 2
}

resource "aws_db_subnet_group" "grocerymate_subnets" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}
resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-db-sg"
  description = "Allow PostgreSQL traffic from EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "PostgreSQL from EC2 SG"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-db-sg"
  }
}

resource "aws_db_instance" "grocerymate_rds" {
  identifier          = "grocerymate-db-${random_id.rds_suffix.hex}"
  engine              = "postgres"
  engine_version      = "17.6"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  storage_type        = "gp2"
  db_name             = "grocerymate_db"
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true
  publicly_accessible = false

  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.grocerymate_subnets.name

  backup_retention_period = 1
  multi_az                = false
  deletion_protection     = false

  tags = {
    Name        = "${var.project_name}-rds"
    Environment = var.environment
  }
}