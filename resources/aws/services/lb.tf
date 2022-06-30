resource "aws_lb" "main_alb" {
  enable_deletion_protection = "false"
  idle_timeout               = "60"
  internal                   = "false"
  load_balancer_type         = "application"
  name                       = "${local.r_prefix}-alb"
  security_groups            = [data.aws_security_group.main_alb_sg.id]

  subnets = data.aws_subnets.public_subnets.ids

  tags = {
    Service = "${local.r_prefix}"
  }

  tags_all = {
    Service = "${local.r_prefix}"
  }
}
