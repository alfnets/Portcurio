locals {
  r_prefix = data.aws_ssm_parameter.main_app_name.value
}

variable "vpc" {
  default = {
    cidr_block       = "10.0.0.0/16"
    public_subnet_1  = "10.0.0.0/24"
    public_subnet_2  = "10.0.2.0/24"
    private_subnet_1 = "10.0.1.0/24"
    private_subnet_2 = "10.0.3.0/24"
  }
}

data "aws_ssm_parameter" "main_app_name" {
  name = "/general/main_app_name"
}

data "aws_ssm_parameter" "domain_name" {
  name = "/${local.r_prefix}/domain_name"
}