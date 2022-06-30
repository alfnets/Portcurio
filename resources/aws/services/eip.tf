resource "aws_eip" "stg_main_ecs_on_ec2_eip" {
  instance = data.aws_instance.stg_main_instance.id

  tags = {
    Name    = "${local.r_prefix}-ecs_on_ec2-eip"
    Service = "${local.r_prefix}"
  }

  tags_all = {
    Name    = "${local.r_prefix}-ecs_on_ec2-eip"
    Service = "${local.r_prefix}"
  }

  vpc = "true"

  depends_on = [
    aws_ecs_service.stg_main_ecs_service
  ]
}