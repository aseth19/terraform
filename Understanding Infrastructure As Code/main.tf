provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name      = "ExampleAppServerInstance"
    yor_trace = "eb851c1a-b8e6-4f41-9623-bf7dfd650293"
  }
  ebs_optimized = true
  monitoring    = true
}