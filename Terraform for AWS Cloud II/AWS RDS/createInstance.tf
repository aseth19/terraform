
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  tags = {
    Env       = "prod"
    yor_trace = "adbe71fd-5928-4b16-bc7d-ef33b3273a65"
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
    yor_trace = "6e059059-af7e-4eee-9706-a4c4a4766b85"
  }
  ebs_optimized = true
  monitoring    = true
}

output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip
}
