resource "aws_db_subnet_group" "app_db_subnet_group" {
  description = "${local.r_prefix}-rds-subnet-group"
  name        = "${local.r_prefix}-rds-subnet-group"
  subnet_ids  = data.aws_subnets.privacy_subnets.ids
}
