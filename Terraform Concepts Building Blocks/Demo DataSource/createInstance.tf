
data "aws_availability_zones" "avilable" {}

data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "MyFirstInstnace" {
  ami               = data.aws_ami.latest-ubuntu.id
  instance_type     = "t2.micro"
  availability_zone = data.aws_availability_zones.avilable.names[1]

  provisioner "local-exec" {
    command = "echo ${aws_instance.MyFirstInstnace.private_ip} >> my_private_ips.txt"
  }

  tags = {
    Name      = "custom_instance"
    yor_trace = "3147e1ad-37d1-4af2-a361-d09d68f38abd"
  }
  monitoring    = true
  ebs_optimized = true
}

output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip
}