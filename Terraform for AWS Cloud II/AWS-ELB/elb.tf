#AWS ELB Configuration
resource "aws_elb" "levelup-elb" {
  name            = "levelup-elb"
  subnets         = [aws_subnet.levelupvpc-public-1.id, aws_subnet.levelupvpc-public-2.id]
  security_groups = [aws_security_group.levelup-elb-securitygroup.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name      = "levelup-elb"
    Env       = "prod"
    yor_trace = "f11d3f0c-e072-4727-8967-105dfc84f77a"
  }
}

#Security group for AWS ELB
resource "aws_security_group" "levelup-elb-securitygroup" {
  vpc_id      = aws_vpc.levelupvpc.id
  name        = "levelup-elb-sg"
  description = "security group for Elastic Load Balancer"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "levelup-elb-sg"
    Env       = "prod"
    yor_trace = "745bfa64-b906-4ba4-a45e-8b4e05e1a6f9"
  }
}

#Security group for the Instances
resource "aws_security_group" "levelup-instance" {
  vpc_id      = aws_vpc.levelupvpc.id
  name        = "levelup-instance"
  description = "security group for instances"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.levelup-elb-securitygroup.id]
  }

  tags = {
    Name      = "levelup-instance"
    Env       = "prod"
    yor_trace = "879a40f5-0afd-42e2-a91b-e97c3b5481a8"
  }
}