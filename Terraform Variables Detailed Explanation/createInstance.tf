
resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"

  tags = {
    Name      = "demoinstnce"
    Env       = "prod"
    yor_trace = "74f0a353-17df-4d46-b83b-158ef80ecfa0"
  }

  security_groups = var.Security_Group
  ebs_optimized   = true
  monitoring      = true
}