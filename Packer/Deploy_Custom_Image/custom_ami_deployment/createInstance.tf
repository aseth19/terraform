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
    Env       = "prod"
    yor_trace = "995a2906-3d18-4b68-aa61-dfc04df3ec52"
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
    yor_trace    = "14c3c64c-46fb-45c0-aeae-3b15d2d3233c"
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
    yor_trace    = "7670c51b-2db1-4175-9917-e5fd70e3df2f"
  }
  monitoring    = true
  ebs_optimized = true
}
