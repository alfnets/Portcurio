resource "aws_db_parameter_group" "app_db_parameter_group" {
  description = "${local.r_prefix}-mariadb"
  family      = "mariadb10.6"
  name        = "${local.r_prefix}-mariadb"

  parameter {
    apply_method = "immediate"
    name         = "character_set_client"
    value        = "utf8mb4"
  }

  parameter {
    apply_method = "immediate"
    name         = "character_set_connection"
    value        = "utf8mb4"
  }

  parameter {
    apply_method = "immediate"
    name         = "character_set_database"
    value        = "utf8mb4"
  }

  parameter {
    apply_method = "immediate"
    name         = "character_set_results"
    value        = "utf8mb4"
  }

  parameter {
    apply_method = "immediate"
    name         = "character_set_server"
    value        = "utf8mb4"
  }

  parameter {
    apply_method = "immediate"
    name         = "collation_connection"
    value        = "utf8mb4_bin"
  }

  parameter {
    apply_method = "immediate"
    name         = "collation_server"
    value        = "utf8mb4_bin"
  }
}
