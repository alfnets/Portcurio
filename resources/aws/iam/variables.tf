locals {
  r_prefix = data.aws_ssm_parameter.main_app_name.value
}

data "aws_ssm_parameter" "main_app_name" {
  name     = "/general/main_app_name"
  provider = aws.tokyo
}