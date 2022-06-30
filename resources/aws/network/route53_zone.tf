resource "aws_route53_zone" "main_route53_zone" {
  comment       = local.r_prefix
  force_destroy = "false"
  name          = data.aws_ssm_parameter.domain_name.value
}
