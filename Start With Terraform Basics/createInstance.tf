
resource "aws_instance" "MyFirstInstnace" {
  count         = 3
  ami           = "ami-0bff25b43a4479334"
  instance_type = "t4g.micro"

  tags = {
    Name      = "demoinstnce-${count.index}"
    yor_trace = "3c386f94-77a5-4eca-bfac-283dfc4201bc"
  }
  ebs_optimized = true
  monitoring    = true
}