
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  tags = {
    yor_trace = "d11f1c78-25e5-4dbd-ae66-3ad90d81b1ad"
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
    yor_trace = "7d26630f-6085-4c0e-adbb-195889dfc88d"
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
    yor_trace = "59dbe2bc-de41-4061-b4f5-9f9c92500e08"
  }
}

#Atatch EBS volume with AWS Instance
resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.ebs-volume-1.id
  instance_id = aws_instance.MyFirstInstnace.id
}