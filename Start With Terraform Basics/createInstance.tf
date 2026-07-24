
resource "aws_instance" "MyFirstInstnace" {
  count         = 3
  ami           = "ami-0bff25b43a4479334"
  instance_type = "t4g.micro"

  tags = {
    Name      = "demoinstnce-${count.index}"
    Env       = "prod"
    yor_trace = "2cd19625-f16a-4be3-a25a-27be9470bd08"
  }
  ebs_optimized = true
  monitoring    = true
}