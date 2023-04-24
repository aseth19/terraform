
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  tags = {
    yor_trace = "5bed8135-3991-4fd0-b5d5-dcb9e5058a93"
  }
}

#Create AWS Instance
resource "aws_instance" "MyFirstInstnace" {
  ami               = lookup(var.AMIS, var.AWS_REGION)
  instance_type     = "t2.micro"
  availability_zone = "us-east-2a"
  key_name          = aws_key_pair.levelup_key.key_name

  iam_instance_profile = aws_iam_instance_profile.s3-levelupbucket-role-instanceprofile.name

  tags = {
    Name      = "custom_instance"
    yor_trace = "1c73d05c-2c1b-4a18-9398-b3ac5c540ea2"
  }
  ebs_optimized = true
  monitoring    = true
}

output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip
}
