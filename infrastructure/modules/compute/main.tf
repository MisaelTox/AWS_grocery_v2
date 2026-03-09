##############################################
# COMPUTE MODULE - GroceryMate EC2 Instance
##############################################

# ----------------------------------------------------------
# AMI Lookup (Amazon Linux 2)
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
# EC2 Instance running GroceryMate in Docker
# ----------------------------------------------------------
resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  key_name                    = var.key_name
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = true

  # Bootstrap with user_data template
  # NOTE: For production, db_password should be retrieved from
  # AWS Secrets Manager at runtime instead of passed via user_data
  user_data = templatefile("${path.module}/../../user_data.tpl", {
    db_host     = var.db_host
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
  })

  tags = merge(var.common_tags, { Name = "${var.project_name}-ec2" })

  lifecycle {
    create_before_destroy = true
  }
}
