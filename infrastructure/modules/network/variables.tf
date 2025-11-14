variable "project_name" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "aws_region" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr_a" {
  type = string
}

variable "private_subnet_cidr_b" {
  type = string
}

variable "allowed_ssh_cidrs" {
  type = list(string)
}

variable "allowed_http_cidrs" {
  type = list(string)
}
