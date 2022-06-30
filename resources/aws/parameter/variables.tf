locals {
  provider_region = "ap-northeast-1"
  r_prefix        = data.aws_ssm_parameter.main_app_name.value
}

data "aws_ssm_parameter" "main_app_name" {
  name = "/general/main_app_name"
}

data "aws_ssm_parameter" "aws_account_id" {
  name = "/general/aws_account_id"
}

data "aws_db_instance" "app_db_instance" {
  db_instance_identifier = "${local.r_prefix}-app-db"
}