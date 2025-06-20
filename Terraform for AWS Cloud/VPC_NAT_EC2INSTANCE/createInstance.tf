
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  tags = {
    Env       = "prod"
    yor_trace = "55655934-497e-4009-a945-ab0c013a93ca"
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
    yor_trace = "9ef9808a-de4b-41af-902a-4bdf3e0e6d38"
  }

  ebs_optimized = true
  monitoring    = true
}