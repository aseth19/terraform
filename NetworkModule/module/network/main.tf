#AWS VPC Resource
resource "aws_vpc" "levelup_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Environment = var.environment_tag
    yor_trace   = "def6a773-7792-498d-9285-470a65f48290"
  }
}

#AWS Internet Gateway
resource "aws_internet_gateway" "levelup_igw" {
  vpc_id = aws_vpc.levelup_vpc.id

  tags = {
    Environment = var.environment_tag
    yor_trace   = "ec900c17-3c31-44f1-91d7-fc136f7f6f28"
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
    yor_trace   = "20551bee-2c1b-4933-ac28-3a09ead8f844"
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
    yor_trace   = "468690fc-5a07-4355-aae1-d8fa79a75b3c"
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
    yor_trace   = "fdb05afc-73e5-4578-a60b-96ecc17101b9"
  }
}