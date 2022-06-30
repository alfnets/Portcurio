locals {
  r_prefix = data.aws_ssm_parameter.main_app_name.value
}

data "aws_vpc" "main_vpc" {
  tags = {
    Name = "${local.r_prefix}-vpc"
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "tag:Service"
    values = ["${local.r_prefix}"]
  }

  filter {
    name   = "tag:Privacy"
    values = ["public"]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "tag:Service"
    values = ["${local.r_prefix}"]
  }

  filter {
    name   = "tag:Privacy"
    values = ["private"]
  }
}

data "aws_subnet" "main_public_subnet_1" {
  tags = {
    Name = "${local.r_prefix}-public-subnet-1"
  }
}

data "aws_subnet" "main_public_subnet_2" {
  tags = {
    Name = "${local.r_prefix}-public-subnet-2"
  }
}

data "aws_subnet" "main_private_subnet_1" {
  tags = {
    Name = "${local.r_prefix}-private-subnet-1"
  }
}

data "aws_subnet" "main_private_subnet_2" {
  tags = {
    Name = "${local.r_prefix}-private-subnet-2"
  }
}

data "aws_internet_gateway" "main_igw" {
  tags = {
    Name = "${local.r_prefix}-igw"
  }
}

data "aws_acm_certificate" "main_acm_certificate" {
  domain = data.aws_ssm_parameter.domain_name.value
}

data "aws_ssm_parameter" "main_app_name" {
  name = "/general/main_app_name"
}

data "aws_ssm_parameter" "domain_name" {
  name = "/${local.r_prefix}/domain_name"
}