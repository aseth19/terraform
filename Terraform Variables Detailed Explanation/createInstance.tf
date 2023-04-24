
resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"

  tags = {
    Name      = "demoinstnce"
    yor_trace = "e9894c9d-5a86-4e4f-bac5-bcfb4f24c66c"
  }

  security_groups = var.Security_Group
  ebs_optimized   = true
  monitoring      = true
}