
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
    yor_trace = "8ea6531b-4381-436b-95d8-b45af57740d3"
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
    yor_trace = "a06fd069-f8a1-4d05-b1b3-7fe1277dd71b"
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
    yor_trace = "51069dfd-9892-4a64-9a2e-4368dc912d27"
  }
}

# private subnet 1
resource "aws_subnet" "levelup_vpc_private_subnet_1" {
  vpc_id            = aws_vpc.levelup_vpc.id
  cidr_block        = var.LEVELUP_VPC_PRIVATE_SUBNET1_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name      = "${var.ENVIRONMENT}-levelup-vpc-private-subnet-1"
    yor_trace = "276b2ef2-40b7-442e-a516-a60f2ee1e69a"
  }
}
# private subnet 2
resource "aws_subnet" "levelup_vpc_private_subnet_2" {
  vpc_id            = aws_vpc.levelup_vpc.id
  cidr_block        = var.LEVELUP_VPC_PRIVATE_SUBNET2_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name      = "${var.ENVIRONMENT}-levelup-vpc-private-subnet-2"
    yor_trace = "e45b6e5a-1404-43bc-a7d4-a5e989cc747f"
  }
}

# internet gateway
resource "aws_internet_gateway" "levelup_igw" {
  vpc_id = aws_vpc.levelup_vpc.id

  tags = {
    Name      = "${var.ENVIRONMENT}-levelup-vpc-internet-gateway"
    yor_trace = "034d2c01-75e8-4363-b74a-f8d057b779a7"
  }
}

# ELastic IP for NAT Gateway
resource "aws_eip" "levelup_nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.levelup_igw]
  tags = {
    yor_trace = "f3f86af4-c891-4f6d-a383-bcc1ac3925d8"
  }
}

# NAT gateway for private ip address
resource "aws_nat_gateway" "levelup_ngw" {
  allocation_id = aws_eip.levelup_nat_eip.id
  subnet_id     = aws_subnet.levelup_vpc_public_subnet_1.id
  depends_on    = [aws_internet_gateway.levelup_igw]
  tags = {
    Name      = "${var.ENVIRONMENT}-levelup-vpc-NAT-gateway"
    yor_trace = "b58b5c29-bc7c-4aee-b418-30e271410e2a"
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
    yor_trace = "5c5a43c8-d135-4bcc-97c4-5f58c9e19633"
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
    yor_trace = "cd89ce91-c794-43db-8567-27cb2dce69e5"
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