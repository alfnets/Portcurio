resource "aws_db_instance" "app_db_instance" {
  identifier                 = "${local.r_prefix}-app-db"
  engine                     = "mariadb"
  engine_version             = "10.6.7"
  instance_class             = var.db_instance_class
  allocated_storage          = "20"
  max_allocated_storage      = "0"
  storage_type               = "gp2"
  storage_encrypted          = "false"
  username                   = "root"
  password                   = "VeryStrongPassword!"
  multi_az                   = "false"
  publicly_accessible        = "false"
  backup_window              = "14:35-15:05"
  backup_retention_period    = "7"
  maintenance_window         = "wed:19:03-wed:19:33"
  auto_minor_version_upgrade = "true"
  deletion_protection        = "true"
  skip_final_snapshot        = "false"
  port                       = "3306"
  apply_immediately          = "false"
  vpc_security_group_ids     = [data.aws_security_group.main_rds_sg.id]
  parameter_group_name       = aws_db_parameter_group.app_db_parameter_group.name
  option_group_name          = "default:mariadb-10-6"
  db_subnet_group_name       = aws_db_subnet_group.app_db_subnet_group.name
  db_name                    = "${local.r_prefix}_app_production"

  # availability_zone                     = "${var.az}"
  # ca_cert_identifier                    = "rds-ca-2019"
  # copy_tags_to_snapshot                 = "true"
  # customer_owned_ip_enabled             = "false"
  # iam_database_authentication_enabled   = "false"
  # iops                                  = "0"
  # license_model                         = "general-public-license"
  # monitoring_interval                   = "0"
  # performance_insights_enabled          = "false"
  # performance_insights_retention_period = "0"
}
