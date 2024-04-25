resource "aws_security_group" "levelup_webservers_alb" {
  tags = {
    Name      = "${var.ENVIRONMENT}-levelup-webservers-ALB"
    yor_trace = "0474136a-f898-478e-b460-da7659200570"
  }
  name        = "${var.ENVIRONMENT}-levelup-webservers-ALB"
  description = "Created by levelup"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
