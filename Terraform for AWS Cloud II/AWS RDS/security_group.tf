#Security Group for levelupvpc
resource "aws_security_group" "allow-levelup-ssh" {
  vpc_id      = aws_vpc.levelupvpc.id
  name        = "allow-levelup-ssh"
  description = "security group that allows ssh connection"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "allow-levelup-ssh"
    yor_trace = "e028df63-d6fd-4743-8989-6a3199c6b551"
  }
}

#Security Group for MariaDB
resource "aws_security_group" "allow-mariadb" {
  vpc_id      = aws_vpc.levelupvpc.id
  name        = "allow-mariadb"
  description = "security group for Maria DB"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.allow-levelup-ssh.id]
  }

  tags = {
    Name      = "allow-mariadb"
    yor_trace = "7d8277ff-480e-414a-8824-b7679a246648"
  }
}