resource "aws_vpc" "main_vpc" {
  assign_generated_ipv6_cidr_block = "false"
  cidr_block                       = var.vpc.cidr_block
  enable_classiclink               = "false"
  enable_classiclink_dns_support   = "false"
  enable_dns_hostnames             = "true"
  enable_dns_support               = "true"
  instance_tenancy                 = "default"

  tags = {
    Name    = "${local.r_prefix}-vpc"
    Service = "${local.r_prefix}"
  }

  tags_all = {
    Name    = "${local.r_prefix}-vpc"
    Service = "${local.r_prefix}"
  }
}
