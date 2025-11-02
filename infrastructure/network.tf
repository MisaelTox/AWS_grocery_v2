##############################
# network.tf
# Networking Setup (Multi-AZ Ready)
##############################

# -----------------------------
# VPC
# -----------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, { Name = "grocerymate-vpc" })
}

# -----------------------------
# Internet Gateway
# -----------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(local.common_tags, { Name = "grocerymate-igw" })
}

# -----------------------------
# Public Subnet (EC2)
# -----------------------------
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = merge(local.common_tags, { Name = "public-subnet-a" })
}

# -----------------------------
# Private Subnets (RDS)
# -----------------------------
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_a
  availability_zone = "${var.aws_region}a"

  tags = merge(local.common_tags, { Name = "private-subnet-a" })
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_b
  availability_zone = "${var.aws_region}b"

  tags = merge(local.common_tags, { Name = "private-subnet-b" })
}

# -----------------------------
# Route Table (Public)
# -----------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(local.common_tags, { Name = "public-rt" })
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

# -----------------------------
# Security Groups
# -----------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow SSH and HTTP access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "ec2-sg" })
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow PostgreSQL traffic from EC2 only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "rds-sg" })
}
