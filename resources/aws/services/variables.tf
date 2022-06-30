locals {
  r_prefix    = data.aws_ssm_parameter.main_app_name.value
  domain_name = data.aws_ssm_parameter.domain_name.value
}

data "aws_ssm_parameter" "aws_account_id" {
  name = "/general/aws_account_id"
}

data "aws_route53_zone" "main_route53_zone" {
  name = local.domain_name
}

data "aws_iam_role" "ecsInstanceRole" {
  name = "ecsTaskExecutionRole"
}

data "aws_iam_instance_profile" "ecsInstanceProfile" {
  name = "ecsInstanceProfile"
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

data "aws_security_group" "public_sg" {
  name = "${local.r_prefix}-public-sg"
}

data "aws_security_group" "main_app_sg" {
  name = "${local.r_prefix}-app-sg"
}

data "aws_security_group" "main_alb_sg" {
  name = "${local.r_prefix}-alb-sg"
}

data "aws_instance" "stg_main_instance" {
  # instance_state = "running"
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = ["ECS_on_EC2_${local.r_prefix}_asg-${random_string.random_id.result}"]
  }

  depends_on = [
    aws_autoscaling_group.main_stg_autoscaling_group,
    random_string.random_id
  ]
}

resource "random_string" "random_id" {
  length  = 8
  upper   = true
  lower   = true
  number  = true
  special = false
}

data "aws_ssm_parameter" "main_app_name" {
  name = "/general/main_app_name"
}

data "aws_ssm_parameter" "domain_name" {
  name = "/${local.r_prefix}/domain_name"
}