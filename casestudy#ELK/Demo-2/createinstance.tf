
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  tags = {
    yor_trace = "b42f0906-9b9f-47c1-bad6-a695a1a920c9"
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
    yor_trace = "72c8f48b-9338-40b9-af12-48a35b500ba0"
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
    yor_trace = "4e5625c4-5a8a-435b-8cc9-30c7b76fa44c"
  }

  provisioner "file" {
    source      = "elasticsearch.yml"
    destination = "/tmp/elasticsearch.yml"
  }

  provisioner "file" {
    source      = "kibana.yml"
    destination = "/tmp/kibana.yml"
  }

  provisioner "file" {
    source      = "apache-01.conf"
    destination = "/tmp/apache-01.conf"
  }

  provisioner "file" {
    source      = "installELK.sh"
    destination = "/tmp/installELK.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x    /tmp/installELK.sh",
      "sudo sed -i -e 's/\r$//' /tmp/installELK.sh", # Remove the spurious CR characters.
      "sudo /tmp/installELK.sh",
    ]
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
  monitoring    = true
  ebs_optimized = true
}

resource "aws_eip" "ip" {
  instance = aws_instance.MyFirstInstnace.id
  tags = {
    yor_trace = "9542fb99-2f6a-4df3-9a19-dca9bd731c2d"
  }
}

output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip
}
