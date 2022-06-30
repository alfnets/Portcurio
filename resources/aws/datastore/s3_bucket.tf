resource "aws_s3_bucket" "s3_bucket" {
  bucket        = local.r_prefix
  force_destroy = "false"

  object_lock_enabled = "false"

  tags = {
    Service     = "${local.r_prefix}"
    Environment = "production"
  }

  tags_all = {
    Service     = "${local.r_prefix}"
    Environment = "production"
  }
}

resource "aws_s3_bucket" "stg_s3_bucket" {
  bucket        = "stg-${local.r_prefix}"
  force_destroy = "false"

  object_lock_enabled = "false"

  tags = {
    Service     = "${local.r_prefix}"
    Environment = "staging"
  }

  tags_all = {
    Service     = "${local.r_prefix}"
    Environment = "staging"
  }
}
