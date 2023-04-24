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
    yor_trace = "8ce92510-518f-4ba2-8b5f-625b8d6e20a2"
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
    yor_trace   = "5febf6f6-b20f-4cb8-9240-0cbd348a7bfe"
  }
  monitoring    = true
  ebs_optimized = true
}