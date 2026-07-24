
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  tags = {
    Env       = "prod"
    yor_trace = "d20a74cd-8da1-4bfd-9474-386fa61ebc06"
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
    Env       = "prod"
    yor_trace = "aeff7fff-c3ad-4437-8d2d-2a607e5c57fe"
  }

  ebs_optimized = true
  monitoring    = true
}