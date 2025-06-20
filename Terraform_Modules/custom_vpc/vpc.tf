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
    yor_trace   = "2cf22856-5869-4536-b80c-0b93bff49403"
  }

}