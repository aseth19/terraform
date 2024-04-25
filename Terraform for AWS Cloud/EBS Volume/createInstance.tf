
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  tags = {
    yor_trace = "ab354f6a-9c47-405b-b343-a7e77fa55ab3"
  }
}

#Create AWS Instance
resource "aws_instance" "MyFirstInstnace" {
  ami               = lookup(var.AMIS, var.AWS_REGION)
  instance_type     = "t2.micro"
  availability_zone = "us-east-2a"
  key_name          = aws_key_pair.levelup_key.key_name

  tags = {
    Name      = "custom_instance"
    yor_trace = "1d91f645-6981-41fa-bd56-3c3a54450cba"
  }
  ebs_optimized = true
  monitoring    = true
}

#EBS resource Creation
resource "aws_ebs_volume" "ebs-volume-1" {
  availability_zone = "us-east-2a"
  size              = 50
  type              = "gp2"

  tags = {
    Name      = "Secondary Volume Disk"
    yor_trace = "039b691a-0749-48ba-80b4-21eaadc4f569"
  }
}

#Atatch EBS volume with AWS Instance
resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.ebs-volume-1.id
  instance_id = aws_instance.MyFirstInstnace.id
}