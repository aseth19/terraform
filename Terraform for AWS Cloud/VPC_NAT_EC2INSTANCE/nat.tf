#Define External IP 
resource "aws_eip" "levelup-nat" {
  vpc = true
  tags = {
    Env       = "prod"
    yor_trace = "a8e00536-faa6-4546-9928-f8d483728136"
  }
}

resource "aws_nat_gateway" "levelup-nat-gw" {
  allocation_id = aws_eip.levelup-nat.id
  subnet_id     = aws_subnet.levelupvpc-public-1.id
  depends_on    = [aws_internet_gateway.levelup-gw]
  tags = {
    Env       = "prod"
    yor_trace = "c1d8296a-7227-4ea8-9c47-b92c47371a55"
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
    yor_trace = "9399b88e-388d-4cf3-8160-7b317ecdc905"
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