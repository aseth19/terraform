#Provider
provider "aws" {
  region = var.region
}

#Module
module "myvpc" {
  source = "./module/network"
}

#Resource key pair
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.public_key_path)
  tags = {
    yor_trace = "f578bfcf-b6fb-4d52-9438-8066e21ab4f9"
  }
}

#EC2 Instance
resource "aws_instance" "levelup_instance" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = module.myvpc.public_subnet_id
  vpc_security_group_ids = module.myvpc.sg_22_id
  key_name               = aws_key_pair.levelup_key.key_name

  tags = {
    Environment = var.environment_tag
    yor_trace   = "de0eef4b-50cf-4ae2-9dd7-77cf5250618c"
  }
  monitoring    = true
  ebs_optimized = true
}