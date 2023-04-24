#AWS VPC Resource
resource "aws_vpc" "levelup_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Environment = var.environment_tag
    yor_trace   = "a06f1847-5d4e-404e-88ec-ab01d3208efb"
  }
}

#AWS Internet Gateway
resource "aws_internet_gateway" "levelup_igw" {
  vpc_id = aws_vpc.levelup_vpc.id

  tags = {
    Environment = var.environment_tag
    yor_trace   = "94fca3c4-929a-47db-a3bb-89486ec4f5ef"
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
    yor_trace   = "400393f9-085a-41d1-9c6c-6e7eaf77df3b"
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
    yor_trace   = "1daf1ba9-e80c-4b5b-8c61-135033aa55a7"
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
    yor_trace   = "668bdf5c-e853-44a9-b3ad-d16c0e917df2"
  }
}