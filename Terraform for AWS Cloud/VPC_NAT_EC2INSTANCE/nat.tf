#Define External IP 
resource "aws_eip" "levelup-nat" {
  vpc = true
  tags = {
    Env       = "prod"
    yor_trace = "ce670990-ea5b-4cc6-b199-a6214895d537"
  }
}

resource "aws_nat_gateway" "levelup-nat-gw" {
  allocation_id = aws_eip.levelup-nat.id
  subnet_id     = aws_subnet.levelupvpc-public-1.id
  depends_on    = [aws_internet_gateway.levelup-gw]
  tags = {
    Env       = "prod"
    yor_trace = "d9f9784e-5da8-4d1e-90ce-36721bd2518d"
  }
}

resource "aws_route_table" "levelup-private" {
  vpc_id = aws_vpc.levelupvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.levelup-nat-gw.id
  }

  tags = {
    Name      = "levelup-private"
    Env       = "prod"
    yor_trace = "6f68f75a-fc26-404d-bb43-361cf4347dd3"
  }
}

# route associations private
resource "aws_route_table_association" "level-private-1-a" {
  subnet_id      = aws_subnet.levelupvpc-private-1.id
  route_table_id = aws_route_table.levelup-private.id
}

resource "aws_route_table_association" "level-private-1-b" {
  subnet_id      = aws_subnet.levelupvpc-private-2.id
  route_table_id = aws_route_table.levelup-private.id
}

resource "aws_route_table_association" "level-private-1-c" {
  subnet_id      = aws_subnet.levelupvpc-private-3.id
  route_table_id = aws_route_table.levelup-private.id
}