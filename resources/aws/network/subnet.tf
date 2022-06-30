resource "aws_subnet" "public_subnet_1" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = var.vpc.public_subnet_1
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name    = "${local.r_prefix}-public-subnet-1"
    Privacy = "public"
    Service = "${local.r_prefix}"
  }

  tags_all = {
    Name    = "${local.r_prefix}-public-subnet-2"
    Privacy = "public"
    Service = "${local.r_prefix}"
  }

  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_subnet" "public_subnet_2" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = var.vpc.public_subnet_2
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name    = "${local.r_prefix}-public-subnet-2"
    Privacy = "public"
    Service = "${local.r_prefix}"
  }

  tags_all = {
    Name    = "${local.r_prefix}-public-subnet-2"
    Privacy = "public"
    Service = "${local.r_prefix}"
  }

  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_subnet" "private_subnet_1" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = var.vpc.private_subnet_1
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name    = "${local.r_prefix}-private-subnet-1"
    Privacy = "private"
    Service = "${local.r_prefix}"
  }

  tags_all = {
    Name    = "${local.r_prefix}-private-subnet-1"
    Privacy = "private"
    Service = "${local.r_prefix}"
  }

  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_subnet" "private_subnet_2" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = var.vpc.private_subnet_2
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name    = "${local.r_prefix}-private-subnet-2"
    Privacy = "private"
    Service = "${local.r_prefix}"
  }

  tags_all = {
    Name    = "${local.r_prefix}-private-subnet-2"
    Privacy = "private"
    Service = "${local.r_prefix}"
  }

  vpc_id = aws_vpc.main_vpc.id
}