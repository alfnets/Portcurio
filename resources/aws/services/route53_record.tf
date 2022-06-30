resource "aws_route53_record" "main_route53_record_A" {
  alias {
    evaluate_target_health = "true"
    name                   = aws_lb.main_alb.dns_name
    zone_id                = aws_lb.main_alb.zone_id
  }

  name    = local.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.main_route53_zone.zone_id
}


resource "aws_route53_record" "main_route53_recode_acm_certificate" {
  for_each = {
    for dvo in aws_acm_certificate.main_acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main_route53_zone.zone_id
}


resource "aws_route53_record" "stg_main_route53_record_A" {
  name    = "stg.${local.domain_name}"
  records = [aws_eip.stg_main_ecs_on_ec2_eip.public_ip]
  ttl     = "300"
  type    = "A"
  zone_id = data.aws_route53_zone.main_route53_zone.zone_id

  depends_on = [
    aws_eip.stg_main_ecs_on_ec2_eip
  ]
}