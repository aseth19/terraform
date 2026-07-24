#Create AWS VPC
resource "aws_vpc" "levelupvpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags = {
    Name      = "levelupvpc"
    Env       = "prod"
    yor_trace = "dd240d5a-da2d-483e-b282-0b8b8a0230d4"
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
    Env       = "prod"
    yor_trace = "7e079ee3-26d3-400f-8848-0e082c2f47b3"
  }
}

resource "aws_subnet" "levelupvpc-public-2" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2b"

  tags = {
    Name      = "levelupvpc-public-2"
    Env       = "prod"
    yor_trace = "87992b19-234a-49ae-bbf4-8c716f36a75f"
  }
}

resource "aws_subnet" "levelupvpc-public-3" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2c"

  tags = {
    Name      = "levelupvpc-public-3"
    Env       = "prod"
    yor_trace = "c95ffc48-809a-4703-8bfc-51e628910354"
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
    Env       = "prod"
    yor_trace = "317523f6-cfba-47d1-9aa9-5f5f9e89e97f"
  }
}

resource "aws_subnet" "levelupvpc-private-2" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2b"

  tags = {
    Name      = "levelupvpc-private-2"
    Env       = "prod"
    yor_trace = "018bee03-f886-4c58-bca0-48bf03e0e888"
  }
}

resource "aws_subnet" "levelupvpc-private-3" {
  vpc_id                  = aws_vpc.levelupvpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2c"

  tags = {
    Name      = "levelupvpc-private-3"
    Env       = "prod"
    yor_trace = "0f94cec0-006e-4735-994d-68e1bc955083"
  }
}

# Custom internet Gateway
resource "aws_internet_gateway" "levelup-gw" {
  vpc_id = aws_vpc.levelupvpc.id

  tags = {
    Name      = "levelup-gw"
    Env       = "prod"
    yor_trace = "ffe6e846-9f64-47b3-8ccd-960893e41ff4"
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
    Env       = "prod"
    yor_trace = "a758d17e-5f2d-4c34-89cf-26b5b22ad746"
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
