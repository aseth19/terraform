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
    yor_trace = "13f1b97b-7a95-4cf4-8207-88e2d78a9aa1"
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
    yor_trace    = "f853c7c7-00e1-487d-a15b-9949a7f3a29e"
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
    yor_trace    = "8181f086-3dcd-469c-8ff1-8775381569f8"
  }
  monitoring    = true
  ebs_optimized = true
}
