
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  tags = {
    yor_trace = "2b64b5fc-a986-4df6-81b7-c371fbdd8c75"
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
    yor_trace = "4ab04837-5836-49e3-ac4e-5d22dfd258dd"
  }
  ebs_optimized = true
  monitoring    = true
}

output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip
}
