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
    yor_trace  = "6426e389-a606-4731-9a37-6c47017aca4b"
  }
}