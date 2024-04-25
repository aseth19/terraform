provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name      = "ExampleAppServerInstance"
    yor_trace = "342389ca-19ee-4b5d-a95e-94f4cfa94c8f"
  }
  ebs_optimized = true
  monitoring    = true
}