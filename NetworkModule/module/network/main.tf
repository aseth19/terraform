#AWS VPC Resource
resource "aws_vpc" "levelup_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Environment = var.environment_tag
    yor_trace   = "41a0363f-ca1c-4b5f-8ae4-b0fd03439a73"
  }
}

#AWS Internet Gateway
resource "aws_internet_gateway" "levelup_igw" {
  vpc_id = aws_vpc.levelup_vpc.id

  tags = {
    Environment = var.environment_tag
    yor_trace   = "afb38af6-8d4c-42d2-bbc1-ac5c2595aa44"
  }
}

# AWS Subnet for VPC
resource "aws_subnet" "subnet_public" {
  vpc_id                  = aws_vpc.levelup_vpc.id
  cidr_block              = var.cidr_subnet
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone

  tags = {
    Environment = var.environment_tag
    yor_trace   = "c2dde521-5cfa-4668-bf92-43d64b434432"
  }
}

# AWS Route Table
resource "aws_route_table" "levelup_rtb_public" {
  vpc_id = aws_vpc.levelup_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.levelup_igw.id
  }

  tags = {
    Environment = var.environment_tag
    yor_trace   = "1e16e991-ff2f-4e17-af39-453cb0552c7d"
  }
}

# AWS Route Association 
resource "aws_route_table_association" "levelup_rta_subnet_public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.levelup_rtb_public.id
}

# AWS Security group
resource "aws_security_group" "levelup_sg_22" {
  name   = "levelup_sg_22"
  vpc_id = aws_vpc.levelup_vpc.id

  # SSH access from the VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment_tag
    yor_trace   = "c1644ac8-09fa-49bf-aebd-19823323a191"
  }
}