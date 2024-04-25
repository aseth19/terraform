
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  tags = {
    yor_trace = "56c44b1b-55ce-4e78-803d-e4911de40184"
  }
}

resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.levelup_key.key_name

  vpc_security_group_ids = [aws_security_group.allow-levelup-ssh.id]
  subnet_id              = aws_subnet.levelupvpc-public-2.id

  tags = {
    Name      = "custom_instance"
    yor_trace = "986165c5-daaa-432a-8d30-ce6b3ecb8ff6"
  }

  ebs_optimized = true
  monitoring    = true
}