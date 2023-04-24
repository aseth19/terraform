
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  tags = {
    yor_trace = "6a4e3fa3-e517-4eec-951e-3a8cd0893b2a"
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
    yor_trace = "f9792eb7-0d07-44ee-b025-269e250f3e0b"
  }

  ebs_optimized = true
  monitoring    = true
}