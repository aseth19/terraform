data "aws_ip_ranges" "us_east_ip_range" {
  regions  = ["us-east-1", "us-east-2"]
  services = ["ec2"]
}

resource "aws_security_group" "sg-custom_us_east" {
  name = "custom_us_east"

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = slice(data.aws_ip_ranges.us_east_ip_range.cidr_blocks, 0, 50)
  }

  tags = {
    CreateDate = data.aws_ip_ranges.us_east_ip_range.create_date
    SyncToken  = data.aws_ip_ranges.us_east_ip_range.sync_token
    Env        = "prod"
    yor_trace  = "f0e7ab7b-c7b3-42a4-a0a2-9bf88f1008c1"
  }
}