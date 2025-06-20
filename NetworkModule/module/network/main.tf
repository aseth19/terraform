#AWS VPC Resource
resource "aws_vpc" "levelup_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Environment = var.environment_tag
    yor_trace   = "1dfc4474-ad41-4305-a252-9a28d095f563"
  }
}

#AWS Internet Gateway
resource "aws_internet_gateway" "levelup_igw" {
  vpc_id = aws_vpc.levelup_vpc.id

  tags = {
    Environment = var.environment_tag
    yor_trace   = "00990fd2-b035-4cac-84bb-99e8edefcb43"
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
    yor_trace   = "09d5f802-36d0-4983-a3fc-c26ddebb0ecd"
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
    yor_trace   = "aad574f3-0666-40de-a738-132ad5a9949f"
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
    yor_trace   = "5bf51289-c8cb-40cb-9db5-88484b79694b"
  }
}