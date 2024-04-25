
resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"

  tags = {
    Name      = "demoinstnce"
    yor_trace = "0bba0336-373f-4292-a023-e7a1b555c33d"
  }

  security_groups = var.Security_Group
  ebs_optimized   = true
  monitoring      = true
}