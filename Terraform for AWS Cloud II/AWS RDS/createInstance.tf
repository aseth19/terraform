
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  tags = {
    yor_trace = "707c3e29-6c49-4130-bcff-0c49bd2b3b7d"
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
    yor_trace = "1999f926-8dd1-4f00-b841-45a095a434fb"
  }
  ebs_optimized = true
  monitoring    = true
}

output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip
}
