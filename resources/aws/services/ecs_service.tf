resource "aws_ecs_service" "main_ecs_service" {
  cluster = "${local.r_prefix}-cluster"

  deployment_circuit_breaker {
    enable   = "false"
    rollback = "false"
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_maximum_percent         = "200"
  deployment_minimum_healthy_percent = "100"
  desired_count                      = "2"
  enable_ecs_managed_tags            = "true"
  enable_execute_command             = "true"
  health_check_grace_period_seconds  = "420"
  launch_type                        = "FARGATE"

  load_balancer {
    container_name   = "nginx"
    container_port   = "80"
    target_group_arn = aws_lb_target_group.main_alb_target_group.arn
  }

  name = "${local.r_prefix}-service"

  network_configuration {
    assign_public_ip = "true"
    security_groups  = ["${data.aws_security_group.main_app_sg.id}"]
    subnets          = data.aws_subnets.public_subnets.ids
  }

  # platform_version    = "LATEST"
  # scheduling_strategy = "REPLICA"

  tags = {
    Service     = "${local.r_prefix}"
    Environment = "production"
  }

  tags_all = {
    Service     = "${local.r_prefix}"
    Environment = "production"
  }

  task_definition = aws_ecs_task_definition.main_ecs_task_definition.arn

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
}


resource "aws_ecs_service" "stg_main_ecs_service" {
  cluster = "stg-${local.r_prefix}-cluster"

  deployment_circuit_breaker {
    enable   = "false"
    rollback = "false"
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_maximum_percent         = "200"
  deployment_minimum_healthy_percent = "100"
  desired_count                      = "1"
  enable_ecs_managed_tags            = "true"
  enable_execute_command             = "false"
  health_check_grace_period_seconds  = "0"
  launch_type                        = "EC2"
  name                               = "stg-${local.r_prefix}-service"

  ordered_placement_strategy {
    field = "memory"
    type  = "binpack"
  }

  scheduling_strategy = "REPLICA"

  tags = {
    Service     = "${local.r_prefix}"
    Environment = "staging"
  }

  tags_all = {
    Service     = "${local.r_prefix}"
    Environment = "staging"
  }

  task_definition = aws_ecs_task_definition.stg_main_ecs_task_definition.arn

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
}
