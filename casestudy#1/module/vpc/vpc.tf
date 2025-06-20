
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
    yor_trace = "4e1c8176-4138-4d4a-b945-033c5df54a73"
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
    yor_trace = "101bc90c-d29a-4b7f-bd5c-090a57b5d50e"
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
    yor_trace = "7b9623a2-3e2a-4952-a1c3-ea7ee2a8bf59"
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
    yor_trace = "9d030652-743b-4c18-9a62-86f64c364e81"
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
    yor_trace = "1df3c52c-cd26-4871-af14-d6143d2c1a66"
  }
}

# internet gateway
resource "aws_internet_gateway" "levelup_igw" {
  vpc_id = aws_vpc.levelup_vpc.id

  tags = {
    Name      = "${var.ENVIRONMENT}-levelup-vpc-internet-gateway"
    Env       = "prod"
    yor_trace = "89def7a4-68a2-4b3a-b1d4-da897a61f45d"
  }
}

# ELastic IP for NAT Gateway
resource "aws_eip" "levelup_nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.levelup_igw]
  tags = {
    Env       = "prod"
    yor_trace = "ab17e24c-0948-438e-a808-d9f2d2bab4a8"
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
    yor_trace = "8b22ea25-af72-4988-a437-91223baaaf6b"
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
    yor_trace = "a98a741a-f5f9-4696-a6eb-f2f873ec074a"
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
    yor_trace = "40ab573b-3853-41cd-9371-08cde71d001e"
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