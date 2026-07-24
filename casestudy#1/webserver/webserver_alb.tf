resource "aws_security_group" "levelup_webservers_alb" {
  tags = {
    Name      = "${var.ENVIRONMENT}-levelup-webservers-ALB"
    Env       = "prod"
    yor_trace = "0d98f1d9-a8ee-443f-a84b-30b7f5458a56"
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
