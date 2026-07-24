
resource "aws_key_pair" "levelup_key" {
  key_name   = "levelup_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
  tags = {
    Env       = "prod"
    yor_trace = "4355fb01-c616-4c5e-a63a-e755a6b14bc7"
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
    Env       = "prod"
    yor_trace = "ff264831-b9ad-4c75-bfd5-fa6ee146dd17"
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
    Env       = "prod"
    yor_trace = "d51426ee-d8c4-4a8b-a8d4-b35300e37b05"
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
    Env       = "prod"
    yor_trace = "91ed0793-077d-45d9-98aa-bb658ec3d904"
  }
}

output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip
}
