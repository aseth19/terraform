
data "aws_availability_zones" "available" {
  state = "available"
}

# Main  vpc
resource "aws_vpc" "levelup_vpc" {
  cidr_block           = var.LEVELUP_VPC_CIDR_BLOC
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name      = "${var.ENVIRONMENT}-vpc"
    Env       = "prod"
    yor_trace = "2b20844b-3897-40df-b10a-a570abe3f472"
  }
}

# Public subnets

#public Subnet 1
resource "aws_subnet" "levelup_vpc_public_subnet_1" {
  vpc_id                  = aws_vpc.levelup_vpc.id
  cidr_block              = var.LEVELUP_VPC_PUBLIC_SUBNET1_CIDR_BLOCK
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = "true"
  tags = {
    Name      = "${var.ENVIRONMENT}-levelup-vpc-public-subnet-1"
    Env       = "prod"
    yor_trace = "6da27e60-24fd-49ad-82b3-0c4ec85bfe4d"
  }
}
#public Subnet 2
resource "aws_subnet" "levelup_vpc_public_subnet_2" {
  vpc_id                  = aws_vpc.levelup_vpc.id
  cidr_block              = var.LEVELUP_VPC_PUBLIC_SUBNET2_CIDR_BLOCK
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = "true"
  tags = {
    Name      = "${var.ENVIRONMENT}-levelup-vpc-public-subnet-2"
    Env       = "prod"
    yor_trace = "1f350339-b17f-4192-8681-720d67c5ea28"
  }
}

# private subnet 1
resource "aws_subnet" "levelup_vpc_private_subnet_1" {
  vpc_id            = aws_vpc.levelup_vpc.id
  cidr_block        = var.LEVELUP_VPC_PRIVATE_SUBNET1_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name      = "${var.ENVIRONMENT}-levelup-vpc-private-subnet-1"
    Env       = "prod"
    yor_trace = "d889284f-19f9-4896-ad16-75bf31163676"
  }
}
# private subnet 2
resource "aws_subnet" "levelup_vpc_private_subnet_2" {
  vpc_id            = aws_vpc.levelup_vpc.id
  cidr_block        = var.LEVELUP_VPC_PRIVATE_SUBNET2_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name      = "${var.ENVIRONMENT}-levelup-vpc-private-subnet-2"
    Env       = "prod"
    yor_trace = "64a32cec-a458-4ad1-9465-962ec27ed97a"
  }
}

# internet gateway
resource "aws_internet_gateway" "levelup_igw" {
  vpc_id = aws_vpc.levelup_vpc.id

  tags = {
    Name      = "${var.ENVIRONMENT}-levelup-vpc-internet-gateway"
    Env       = "prod"
    yor_trace = "604cbac3-d77e-479f-b5d2-d08ecd7196c5"
  }
}

# ELastic IP for NAT Gateway
resource "aws_eip" "levelup_nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.levelup_igw]
  tags = {
    Env       = "prod"
    yor_trace = "5e84c707-aeef-42f3-8b23-a1d0117d5a3f"
  }
}

# NAT gateway for private ip address
resource "aws_nat_gateway" "levelup_ngw" {
  allocation_id = aws_eip.levelup_nat_eip.id
  subnet_id     = aws_subnet.levelup_vpc_public_subnet_1.id
  depends_on    = [aws_internet_gateway.levelup_igw]
  tags = {
    Name      = "${var.ENVIRONMENT}-levelup-vpc-NAT-gateway"
    Env       = "prod"
    yor_trace = "9399b5ac-aa56-4ca9-947e-b31eeb841bdf"
  }
}

# Route Table for public Architecture
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.levelup_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.levelup_igw.id
  }

  tags = {
    Name      = "${var.ENVIRONMENT}-levelup-public-route-table"
    Env       = "prod"
    yor_trace = "fbd098a3-c679-4b82-b96b-1d20895fa522"
  }
}

# Route table for Private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.levelup_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.levelup_ngw.id
  }

  tags = {
    Name      = "${var.ENVIRONMENT}-levelup-private-route-table"
    Env       = "prod"
    yor_trace = "a393a14e-03f5-497e-8591-0e4364c5b772"
  }
}

# Route Table association with public subnets
resource "aws_route_table_association" "to_public_subnet1" {
  subnet_id      = aws_subnet.levelup_vpc_public_subnet_1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "to_public_subnet2" {
  subnet_id      = aws_subnet.levelup_vpc_public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

# Route table association with private subnets
resource "aws_route_table_association" "to_private_subnet1" {
  subnet_id      = aws_subnet.levelup_vpc_private_subnet_1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "to_private_subnet2" {
  subnet_id      = aws_subnet.levelup_vpc_private_subnet_2.id
  route_table_id = aws_route_table.private.id
}

provider "aws" {
  region = var.AWS_REGION
}

#Output Specific to Custom VPC
output "my_vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.levelup_vpc.id
}

output "private_subnet1_id" {
  description = "Subnet ID"
  value       = aws_subnet.levelup_vpc_private_subnet_1.id
}

output "private_subnet2_id" {
  description = "Subnet ID"
  value       = aws_subnet.levelup_vpc_private_subnet_2.id
}

output "public_subnet1_id" {
  description = "Subnet ID"
  value       = aws_subnet.levelup_vpc_public_subnet_1.id
}

output "public_subnet2_id" {
  description = "Subnet ID"
  value       = aws_subnet.levelup_vpc_private_subnet_2.id
}