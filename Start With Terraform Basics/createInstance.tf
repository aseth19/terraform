
resource "aws_instance" "MyFirstInstnace" {
  count         = 3
  ami           = "ami-0bff25b43a4479334"
  instance_type = "t4g.micro"

  tags = {
    Name      = "demoinstnce-${count.index}"
    yor_trace = "95d347b2-fa18-4eb8-be26-61c25f92ba65"
  }
  ebs_optimized = true
  monitoring    = true
}