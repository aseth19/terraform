
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  tags = {
    yor_trace = "1b2941c5-5eb5-4ed3-a245-b288b53438e1"
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
    yor_trace = "6ba4e746-9cd2-407d-8f07-3e4165546d4e"
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
    yor_trace = "5a93b3db-61c0-4d7a-98ee-657f16581465"
  }
  ebs_optimized = true
  monitoring    = true
}

resource "aws_eip" "ip" {
  instance = aws_instance.MyFirstInstnace.id
  tags = {
    yor_trace = "2e04bf24-b451-42d7-9204-7861b9912009"
  }
}

output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip
}
