resource "aws_db_instance" "grocerymate_rds" {
  identifier              = "grocerymate-db"
  engine                  = "postgres"
  engine_version          = "15.3"
  instance_class          = "db.t3.micro"       
  allocated_storage       = 20                  
  storage_type            = "gp2"
  db_name                 = "grocerymate_db"
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  publicly_accessible     = false

  vpc_security_group_ids  = [aws_security_group.web_sg.id]

  backup_retention_period = 1                   
  multi_az                = false               
  deletion_protection     = false

  tags = {
    Name        = "${var.project_name}-rds"
    Environment = var.environment
  }
}
