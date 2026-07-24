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
    yor_trace = "8c4b78e1-40e3-49bf-b654-8cbed88cd49e"
  }
  ebs_optimized = true
  monitoring    = true
}