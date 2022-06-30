resource "aws_acm_certificate" "main_acm_certificate" {
  domain_name = local.domain_name

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

## wait DNS record inspection (change for DNS record inspection by Terraform AWS Provider 3.0.0up)
resource "aws_acm_certificate_validation" "main_acm_certificate_validation" {
  certificate_arn         = aws_acm_certificate.main_acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.main_route53_recode_acm_certificate : record.fqdn]


  depends_on = [
    aws_route53_record.main_route53_recode_acm_certificate
  ]
}