
resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"

  tags = {
    Name      = "demoinstnce"
    Env       = "prod"
    yor_trace = "94cc2dd1-b930-4e41-af4e-23f8e72a1860"
  }

  security_groups = var.Security_Group
  ebs_optimized   = true
  monitoring      = true
}