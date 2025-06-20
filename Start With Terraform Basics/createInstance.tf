
resource "aws_instance" "MyFirstInstnace" {
  count         = 3
  ami           = "ami-0bff25b43a4479334"
  instance_type = "t4g.micro"

  tags = {
    Name      = "demoinstnce-${count.index}"
    Env       = "prod"
    yor_trace = "d66051d4-1bff-4d5b-866b-4e72a99b82e8"
  }
  ebs_optimized = true
  monitoring    = true
}