
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  tags = {
    Env       = "prod"
    yor_trace = "5c32bee7-3ce0-4ec8-85ac-45d5d3a394b8"
  }
}

#Create AWS Instance
resource "aws_instance" "MyFirstInstnace" {
  ami                    = lookup(var.AMIS, var.AWS_REGION)
  instance_type          = "t2.micro"
  availability_zone      = "us-east-2a"
  key_name               = aws_key_pair.levelup_key.key_name
  vpc_security_group_ids = [aws_security_group.allow-levelup-ssh.id]
  subnet_id              = aws_subnet.levelupvpc-public-1.id

  tags = {
    Name      = "custom_instance"
    Env       = "prod"
    yor_trace = "a3b986f6-42d1-47fc-953b-d69a3384c26e"
  }
  ebs_optimized = true
  monitoring    = true
}

output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip
}
