
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  tags = {
    yor_trace = "1c5c6198-e586-4c12-b0b6-a80b075ce200"
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
    yor_trace = "cb1ec2ff-c4a1-4e9d-b1cd-04883d5f925d"
  }
  ebs_optimized = true
  monitoring    = true
}

output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip
}
