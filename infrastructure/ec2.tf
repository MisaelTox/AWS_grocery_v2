##############################################
# EC2 Instance - GroceryMate Application
##############################################

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/user_data.tpl", {
    db_host     = aws_db_instance.postgres.address
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
  })

  tags = merge(local.common_tags, { Name = "GroceryMate-EC2" })
}

output "public_ip" {
  description = "Public IP of the GroceryMate EC2 instance"
  value       = aws_instance.app.public_ip
}
