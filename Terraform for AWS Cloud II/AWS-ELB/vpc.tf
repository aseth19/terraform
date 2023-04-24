#Create AWS VPC
resource "aws_vpc" "levelupvpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags = {
    Name      = "levelupvpc"
    yor_trace = "81699b2e-44f2-495b-8978-4864c61a05b1"
  }
}

# Public Subnets in Custom VPC
resource "aws_subnet" "levelupvpc-public-1" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2a"

  tags = {
    Name      = "levelupvpc-public-1"
    yor_trace = "7403b190-e81c-4f92-9834-5e7d68d9b89c"
  }
}

resource "aws_subnet" "levelupvpc-public-2" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2b"

  tags = {
    Name      = "levelupvpc-public-2"
    yor_trace = "7373195c-cb12-4fb8-ba8f-76df441ee003"
  }
}

resource "aws_subnet" "levelupvpc-public-3" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2c"

  tags = {
    Name      = "levelupvpc-public-3"
    yor_trace = "71211aab-28e0-410f-bd3f-bf4c619b2b81"
  }
}

# Private Subnets in Custom VPC
resource "aws_subnet" "levelupvpc-private-1" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2a"

  tags = {
    Name      = "levelupvpc-private-1"
    yor_trace = "8dca9245-0b24-4e12-b7a2-8553c46b8c02"
  }
}

resource "aws_subnet" "levelupvpc-private-2" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2b"

  tags = {
    Name      = "levelupvpc-private-2"
    yor_trace = "ba2fc4e8-9417-492d-8539-a9d244d19c2d"
  }
}

resource "aws_subnet" "levelupvpc-private-3" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2c"

  tags = {
    Name      = "levelupvpc-private-3"
    yor_trace = "8a08122b-2057-49da-bf70-1383bdae6411"
  }
}

# Custom internet Gateway
resource "aws_internet_gateway" "levelup-gw" {
  vpc_id = aws_vpc.levelupvpc.id

  tags = {
    Name      = "levelup-gw"
    yor_trace = "3cbcaf0e-4d97-401c-926c-cb1e1088edd1"
  }
}

#Routing Table for the Custom VPC
resource "aws_route_table" "levelup-public" {
  vpc_id = aws_vpc.levelupvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.levelup-gw.id
  }

  tags = {
    Name      = "levelup-public-1"
    yor_trace = "6608ff92-1814-4350-9f91-5c8b43bc4615"
  }
}

resource "aws_route_table_association" "levelup-public-1-a" {
  subnet_id      = aws_subnet.levelupvpc-public-1.id
  route_table_id = aws_route_table.levelup-public.id
}

resource "aws_route_table_association" "levelup-public-2-a" {
  subnet_id      = aws_subnet.levelupvpc-public-2.id
  route_table_id = aws_route_table.levelup-public.id
}

resource "aws_route_table_association" "levelup-public-3-a" {
  subnet_id      = aws_subnet.levelupvpc-public-3.id
  route_table_id = aws_route_table.levelup-public.id
}
