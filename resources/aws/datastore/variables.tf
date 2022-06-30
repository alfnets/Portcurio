locals {
  r_prefix = data.aws_ssm_parameter.main_app_name.value
}

variable "db_instance_class" {
  default = "db.t2.micro"
}

data "aws_security_group" "main_rds_sg" {
  name = "${local.r_prefix}-rds-sg"
}

data "aws_subnets" "privacy_subnets" {
  filter {
    name   = "tag:Service"
    values = ["${local.r_prefix}"]
  }

  filter {
    name   = "tag:Privacy"
    values = ["private"]
  }
}

data "aws_ssm_parameter" "main_app_name" {
  name = "/general/main_app_name"
}