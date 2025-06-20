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
    yor_trace = "43bb076f-f152-413d-9dba-7490d048c5d5"
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
    yor_trace = "ee6e631c-cbe7-466a-8846-5539576cb70f"
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
    yor_trace = "d2fb868b-709f-4d46-a8cd-cec5ac5368e8"
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
    yor_trace = "c38448ab-af0a-4385-b248-754da2a39028"
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
    yor_trace = "f51cfd29-fa87-49d2-9ce6-8a07613e93b5"
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
    yor_trace = "bed3eb68-400b-4102-ba1d-d7e746e8e8d1"
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
    yor_trace = "bd4b99e3-7f08-49f1-8b22-746bea5c98c4"
  }
}

# Custom internet Gateway
resource "aws_internet_gateway" "levelup-gw" {
  vpc_id = aws_vpc.levelupvpc.id

  tags = {
    Name      = "levelup-gw"
    Env       = "prod"
    yor_trace = "a436c2e8-599c-4ad5-8dad-0e82864e140a"
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
    yor_trace = "96931524-f3c1-48fc-a4b1-3d89ddaf5155"
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
