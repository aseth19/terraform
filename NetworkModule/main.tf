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
    Env       = "prod"
    yor_trace = "205ccb98-bec4-4138-b718-f98f96230f1c"
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
    yor_trace   = "11b5e874-7fce-4d1c-9f94-211830752317"
  }
  monitoring    = true
  ebs_optimized = true
}