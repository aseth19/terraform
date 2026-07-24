
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  tags = {
    Env       = "prod"
    yor_trace = "ea7605c1-eeee-4a4b-b730-d66532d8314b"
  }
}

#Create AWS Instance
resource "aws_instance" "MyFirstInstnace" {
  ami               = lookup(var.AMIS, var.AWS_REGION)
  instance_type     = "t2.micro"
  availability_zone = "us-east-2a"
  key_name          = aws_key_pair.levelup_key.key_name

  user_data = data.template_cloudinit_config.install-apache-config.rendered

  tags = {
    Name      = "custom_instance"
    Env       = "prod"
    yor_trace = "710624e5-a8ed-454e-ba47-e318b9eb9496"
  }
  ebs_optimized = true
  monitoring    = true
}

output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip
}
