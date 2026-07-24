
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  tags = {
    Env       = "prod"
    yor_trace = "bad766b6-e9b9-4177-8a6c-880f3fd552af"
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
    Env       = "prod"
    yor_trace = "1eaea22b-ccfc-4eae-b7c8-ac9e1b55f658"
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
    Env       = "prod"
    yor_trace = "0f6e124a-57b0-46cb-adac-adaa0e101af2"
  }
}

#Atatch EBS volume with AWS Instance
resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.ebs-volume-1.id
  instance_id = aws_instance.MyFirstInstnace.id
}