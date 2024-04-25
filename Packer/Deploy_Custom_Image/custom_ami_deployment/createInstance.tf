# Create Instance uisng Custom VPC

module "develop-vpc" {
  source = "../modules/vpc"

  ENVIRONMENT = var.ENVIRONMENT
  AWS_REGION  = var.AWS_REGION
}

provider "aws" {
  region = var.AWS_REGION
}

#Resource key pair
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.public_key_path)
  tags = {
    yor_trace = "118f4576-5030-4f64-91f6-9ffcc81cfdab"
  }
}

#Secutiry Group for Instances
resource "aws_security_group" "allow-ssh" {
  vpc_id      = module.develop-vpc.my_vpc_id
  name        = "allow-ssh-${var.ENVIRONMENT}"
  description = "security group that allows ssh traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "allow-ssh"
    Environmnent = var.ENVIRONMENT
    yor_trace    = "527c4d59-ade9-4af6-8280-3d76033f3545"
  }
}

# Create Instance Group
resource "aws_instance" "my-instance" {
  ami           = var.AMI_ID
  instance_type = var.INSTANCE_TYPE

  # the VPC subnet
  subnet_id         = element(module.develop-vpc.public_subnets, 0)
  availability_zone = "${var.AWS_REGION}a"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]

  # the public SSH key
  key_name = aws_key_pair.levelup_key.key_name

  tags = {
    Name         = "instance-${var.ENVIRONMENT}"
    Environmnent = var.ENVIRONMENT
    yor_trace    = "e749b29f-8f12-4c9e-a8d2-0fc7d9f25ec2"
  }
  monitoring    = true
  ebs_optimized = true
}
