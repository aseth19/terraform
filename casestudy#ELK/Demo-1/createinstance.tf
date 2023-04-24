
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  tags = {
    yor_trace = "1d12d2c1-7427-43f5-a2f6-9e2b97ff6e83"
  }
}

resource "aws_security_group" "allow_elk" {
  name        = "allow_elk"
  description = "All all elasticsearch traffic"

  # elasticsearch port
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # logstash port
  ingress {
    from_port   = 5043
    to_port     = 5044
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # kibana ports
  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    yor_trace = "77fb0071-3027-4f13-b853-14251ecb3d4a"
  }
}

#Create AWS Instance
resource "aws_instance" "MyFirstInstnace" {
  ami               = lookup(var.AMIS, var.AWS_REGION)
  instance_type     = "m4.large"
  availability_zone = "ap-south-1a"
  key_name          = aws_key_pair.levelup_key.key_name

  vpc_security_group_ids = [
    aws_security_group.allow_elk.id,
  ]

  depends_on = [aws_security_group.allow_elk]

  tags = {
    Name      = "custom_instance"
    yor_trace = "df06fa36-fe8c-4103-821f-086ecd001700"
  }
  ebs_optimized = true
  monitoring    = true
}

resource "aws_eip" "ip" {
  instance = aws_instance.MyFirstInstnace.id
  tags = {
    yor_trace = "16438575-eec6-4d0e-b799-9780b61711db"
  }
}

output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip
}
