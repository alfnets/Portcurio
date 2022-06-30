resource "aws_ssm_parameter" "main_db_host" {
  arn       = "arn:aws:ssm:${local.provider_region}:${data.aws_ssm_parameter.aws_account_id.value}:parameter/${local.r_prefix}/app_main_db_host"
  data_type = "text"
  name      = "/${local.r_prefix}/app_main_db_host"
  tier      = "Standard"
  type      = "String"
  value     = data.aws_db_instance.app_db_instance.address
}

resource "aws_ssm_parameter" "main_db_name" {
  arn       = "arn:aws:ssm:${local.provider_region}:${data.aws_ssm_parameter.aws_account_id.value}:parameter/${local.r_prefix}/app_main_db_name"
  data_type = "text"
  name      = "/${local.r_prefix}/app_main_db_name"
  tier      = "Standard"
  type      = "String"
  value     = "${local.r_prefix}_app_production"
}

resource "aws_ssm_parameter" "stg_main_db_name" {
  arn       = "arn:aws:ssm:${local.provider_region}:${data.aws_ssm_parameter.aws_account_id.value}:parameter/${local.r_prefix}/app_stg_main_db_name"
  data_type = "text"
  name      = "/${local.r_prefix}/app_stg_main_db_name"
  tier      = "Standard"
  type      = "String"
  value     = "${local.r_prefix}_app_staging"
}