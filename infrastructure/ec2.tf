##############################
# ec2.tf
# EC2 instance running GroceryMate in Docker
##############################

# ----------------------------------------------------------
# Amazon Linux 2 AMI (última versión en la región configurada)
# ----------------------------------------------------------
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


# ----------------------------------------------------------
# EC2 Instance con Docker + GroceryMate
# ----------------------------------------------------------
resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  # Archivo de arranque (Bootstrap)
  user_data = templatefile("${path.module}/user_data.tpl", {
    db_host     = aws_db_instance.postgres.address
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
  })

  tags = merge(local.common_tags, { Name = "grocerymate-ec2" })
}

# ----------------------------------------------------------
# Output con IP pública
# ----------------------------------------------------------
output "ec2_public_ip" {
  description = "Public IP address of the GroceryMate EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of the GroceryMate EC2 instance"
  value       = aws_instance.app_server.public_dns
}
