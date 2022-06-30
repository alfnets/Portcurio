resource "aws_ecs_cluster" "main_ecs_cluster" {
  name = "${local.r_prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Service     = "${local.r_prefix}"
    Environment = "production"
  }

  tags_all = {
    Service     = "${local.r_prefix}"
    Environment = "production"
  }
}

resource "aws_ecs_cluster" "stg_main_ecs_cluster" {
  name = "stg-${local.r_prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Service     = "${local.r_prefix}"
    Environment = "staging"
  }

  tags_all = {
    Service     = "${local.r_prefix}"
    Environment = "staging"
  }
}
