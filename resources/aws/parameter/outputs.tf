output "aws_ssm_parameter_main_db_host_id" {
  value = aws_ssm_parameter.main_db_host.id
}

output "aws_ssm_parameter_main_db_name_id" {
  value = aws_ssm_parameter.main_db_name.id
}

output "aws_ssm_parameter_stg_main_db_name_id" {
  value = aws_ssm_parameter.stg_main_db_name.id
}