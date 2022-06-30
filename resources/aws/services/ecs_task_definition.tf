resource "aws_ecs_task_definition" "main_ecs_task_definition" {
  family                   = "${local.r_prefix}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = data.aws_iam_role.ecsInstanceRole.arn
  task_role_arn            = data.aws_iam_role.ecsInstanceRole.arn
  cpu                      = "512"
  memory                   = "1024"
  container_definitions = replace(
    replace(
      jsonencode(jsondecode(file("task-definition/task-definition.json")).containerDefinitions),
      "amazonaws.com/${local.r_prefix}-app",
      "amazonaws.com/${local.r_prefix}-app:${jsondecode(data.external.tags_of_most_recently_pushed_image.result.tags)[0]}"
    ),
    "SED_TARGET_AWS_ACCOUNT_ID",
    "${data.aws_ssm_parameter.aws_account_id.value}"
  )

  runtime_platform {
    operating_system_family = "LINUX"
  }

  lifecycle {
    ignore_changes = [container_definitions]
  }
  skip_destroy = true

  depends_on = [
    aws_ecs_cluster.main_ecs_cluster
  ]
}

resource "aws_ecs_task_definition" "stg_main_ecs_task_definition" {
  family                   = "stg-${local.r_prefix}-task"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = data.aws_iam_role.ecsInstanceRole.arn
  task_role_arn            = data.aws_iam_role.ecsInstanceRole.arn
  container_definitions = replace(
    replace(
      jsonencode(jsondecode(file("task-definition/stg-task-definition.json")).containerDefinitions),
      "amazonaws.com/${local.r_prefix}-app",
      "amazonaws.com/${local.r_prefix}-app:${jsondecode(data.external.tags_of_most_recently_pushed_image.result.tags)[0]}"
    ),
    "SED_TARGET_AWS_ACCOUNT_ID",
    "${data.aws_ssm_parameter.aws_account_id.value}"
  )

  volume {
    docker_volume_configuration {
      autoprovision = "true"
      driver        = "local"

      labels = {
        Name = "letsencrypt"
      }

      scope = "shared"
    }

    name = "letsencrypt"
  }

  lifecycle {
    ignore_changes = [container_definitions]
  }
  skip_destroy = true

  depends_on = [
    aws_ecs_cluster.stg_main_ecs_cluster
  ]
}

data "external" "tags_of_most_recently_pushed_image" {
  program = [
    "aws", "ecr", "describe-images",
    "--repository-name", "${local.r_prefix}-app",
    "--query", "{\"tags\": to_string(sort_by(imageDetails,& imagePushedAt)[-1].imageTags)}",
  ]
}
