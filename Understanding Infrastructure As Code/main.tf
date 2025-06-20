provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name      = "ExampleAppServerInstance"
    Env       = "prod"
    yor_trace = "a81ee087-3ef8-417f-b96f-1948f2cd2eed"
  }
  ebs_optimized = true
  monitoring    = true
}