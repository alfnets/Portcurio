resource "aws_lb_listener_rule" "main_alb_listener_rule" {
  action {
    order = "1"

    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }

    type = "redirect"
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  listener_arn = aws_lb_listener.main_alb_listener_http.id
  priority     = "1"
}
