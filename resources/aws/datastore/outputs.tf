output "aws_db_instance_app_db_instance_id" {
  value = aws_db_instance.app_db_instance.id
}

output "aws_db_parameter_group_app_db_parameter_group_id" {
  value = aws_db_parameter_group.app_db_parameter_group.id
}

output "aws_db_subnet_group_app_db_subnet_group_id" {
  value = aws_db_subnet_group.app_db_subnet_group.id
}

output "aws_db_instance_app_db_instance_address" {
  value = aws_db_instance.app_db_instance.address
}

output "aws_s3_bucket_s3_bucket_id" {
  value = aws_s3_bucket.s3_bucket.id
}

output "aws_s3_bucket_stg_s3_bucket_id" {
  value = aws_s3_bucket.stg_s3_bucket.id
}

output "aws_ecr_repository_main_app_id" {
  value = aws_ecr_repository.main_app.id
}

output "aws_ecr_repository_main_nginx_id" {
  value = aws_ecr_repository.main_nginx.id
}

output "aws_ecr_repository_stg_main_nginx_id" {
  value = aws_ecr_repository.stg_main_nginx.id
}