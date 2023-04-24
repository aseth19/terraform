#Define External IP 
resource "aws_eip" "levelup-nat" {
  vpc = true
  tags = {
    yor_trace = "7ec5ac0e-f887-4c8b-8c7b-fc90c0132294"
  }
}

resource "aws_nat_gateway" "levelup-nat-gw" {
  allocation_id = aws_eip.levelup-nat.id
  subnet_id     = aws_subnet.levelupvpc-public-1.id
  depends_on    = [aws_internet_gateway.levelup-gw]
  tags = {
    yor_trace = "4998a2bd-f725-4c32-b0ff-5229338aad6a"
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
    yor_trace = "2fb2c220-bb2b-4051-a277-70b7bc8c04dd"
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