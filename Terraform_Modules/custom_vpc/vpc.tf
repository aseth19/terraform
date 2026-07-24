# VPC
resource "aws_vpc" "aws_vpc_levelup" {

  cidr_block                       = var.cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  enable_classiclink               = var.enable_classiclink
  enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = {
    name        = var.vpcname
    environment = var.vpcenvironment
    Env         = "prod"
    yor_trace   = "afe952c4-2d09-4c34-8f23-58fc62c44685"
  }

}