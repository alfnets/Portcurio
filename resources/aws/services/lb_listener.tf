resource "aws_lb_listener" "main_alb_listener_https" {
  certificate_arn = aws_acm_certificate.main_acm_certificate.arn

  default_action {
    order            = "1"
    target_group_arn = aws_lb_target_group.main_alb_target_group.arn
    type             = "forward"
  }

  load_balancer_arn = aws_lb.main_alb.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
}

resource "aws_lb_listener" "main_alb_listener_http" {
  default_action {
    order            = "1"
    target_group_arn = aws_lb_target_group.main_alb_target_group.arn
    type             = "forward"
  }

  load_balancer_arn = aws_lb.main_alb.arn
  port              = "80"
  protocol          = "HTTP"

  depends_on = [
    aws_acm_certificate_validation.main_acm_certificate_validation
  ]
}
