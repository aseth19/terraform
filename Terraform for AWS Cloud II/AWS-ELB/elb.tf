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
    yor_trace = "1f2f2f28-0f8b-4317-88a2-1db01554cb8d"
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
    yor_trace = "a3370ee4-27c4-4577-94f2-0368ac03b2a8"
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
    yor_trace = "1c33a9fc-51b1-45af-b1dc-afc5d87d17b3"
  }
}