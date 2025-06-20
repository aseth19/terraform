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
    yor_trace = "ef43b24b-d2bf-4d93-b3ce-20f0b1cb16fb"
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
    yor_trace = "65f8f95b-7bff-4f83-b4cc-15eb86f63410"
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
    yor_trace = "aa55f549-06c5-465c-ad92-a8c4b7b9fa55"
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
    yor_trace = "ea58ef13-3c6a-4901-bae9-533b5e2b10c8"
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
    yor_trace = "783aa5ce-ecb5-4ac9-822d-a15c1efaaf3d"
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
    yor_trace = "bc1152e1-f260-489d-9c29-899ab1992f2a"
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
    yor_trace = "e6b42ba0-3c05-4e76-bf89-8d8af50e8a99"
  }
}

# Custom internet Gateway
resource "aws_internet_gateway" "levelup-gw" {
  vpc_id = aws_vpc.levelupvpc.id

  tags = {
    Name      = "levelup-gw"
    Env       = "prod"
    yor_trace = "05e9e46f-1fba-4418-ab2f-20a2ae609b7c"
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
    yor_trace = "d53f567a-254f-443b-a9c4-8076e6282c74"
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
