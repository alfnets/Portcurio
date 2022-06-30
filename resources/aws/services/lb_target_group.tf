resource "aws_lb_target_group" "main_alb_target_group" {
  deregistration_delay = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "5"
    interval            = "30"
    matcher             = "200"
    path                = "/login"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
    unhealthy_threshold = "5"
  }

  load_balancing_algorithm_type = "round_robin"
  name                          = "${local.r_prefix}-alb-tg"
  port                          = "80"
  protocol                      = "HTTP"
  protocol_version              = "HTTP1"
  slow_start                    = "0"

  stickiness {
    cookie_duration = "86400"
    enabled         = "false"
    type            = "lb_cookie"
  }

  tags = {
    Name    = "${local.r_prefix}-alb-tg"
    Service = "${local.r_prefix}"
  }

  tags_all = {
    Name    = "${local.r_prefix}-alb-tg"
    Service = "${local.r_prefix}"
  }

  target_type = "ip"
  vpc_id      = data.aws_vpc.main_vpc.id

  depends_on = [
    aws_lb.main_alb
  ]
}
